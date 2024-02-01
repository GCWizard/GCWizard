using System;
using System.Windows.Forms;
using System.Diagnostics;
using System.Threading;
using PdfSharp.Pdf;
using System.Collections.Generic;

namespace GC_Wizard_SymbolTables_Pdf
{
    public partial class mainForm : Form
    {

        private Single BorderWidth { get; set; }

        private int ImageSize { get; set; }

        private String Language { get; set; }

        private double FontSizeName { get; set; }

        private double FontSizeOverlay { get; set; }

        private bool NewPage { get; set; }

        private bool Landscape { get; set; }

        private bool ViewPdf { get; set; }

        private String _CurrentProjectPath;
        public String CurrentProjectPath
        {
            get
            {
                return _CurrentProjectPath;
            }
            set
            {
                _CurrentProjectPath = value;
                updateLanguageComboBox();
            }
        }

        private bool OnProcess { get; set; }

        private List<SymbolTablesPdf> activeSymbolTablesPdfs { get; set; } = new List<SymbolTablesPdf>();


        public mainForm()
        {
            InitializeComponent();
        }

        private void openProjectFolderButton_Click(object sender, EventArgs e)
        {
            if (OnProcess)
                return;

            var ofd = new FolderBrowserDialog();

            ofd.Description = "Project Folder";
            ofd.SelectedPath = CurrentProjectPath;

            if (ofd.ShowDialog() == DialogResult.OK)
            {
                CurrentProjectPath = ofd.SelectedPath;
                projectFolderTextBox.Text = CurrentProjectPath;
            }
        }

        private void startButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (OnProcess)
                    return;

                var symbolTablesPdf = new SymbolTablesPdf();
                if (!symbolTablesPdf.validFolder(CurrentProjectPath))
                    return;

                activeSymbolTablesPdfs.Clear();
                ThreadPool.QueueUserWorkItem(createPdf, new List<String>() { CurrentProjectPath, Language });
            }
            catch (Exception)
            {
            }
        }

        private void StartDefaultButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (OnProcess)
                    return;

                var defaultLanguages = new List<String>() { "en", "de", "fr", "ko", "nl", "pl", "sk", "sv" };

                var symbolTablesPdf = new SymbolTablesPdf();
                if (!symbolTablesPdf.validFolder(CurrentProjectPath))
                    return;

                activeSymbolTablesPdfs.Clear();
                foreach (var language in defaultLanguages)
                    ThreadPool.QueueUserWorkItem(createPdf, new List<String>() { CurrentProjectPath, language });

            }
            catch (Exception)
            {
            }
        }

        public void createPdf(object data)

        {
            try
            {
                var path = ((List<String>)data)[0];
                var language = ((List<String>)data)[1];

                var symbolTablesPdf = new SymbolTablesPdf();

                activeSymbolTablesPdfs.Add(symbolTablesPdf);

                symbolTablesPdf.SymbolTablesCount_Changed += SymbolTablesCount_Changed;
                symbolTablesPdf.SymbolImagesCount_Changed += SymbolImagesCount_Changed;
                symbolTablesPdf.Progress_Changed += Progress_Changed;

                symbolTablesPdf.BorderWidthTop = 35;// BorderWidth;
                symbolTablesPdf.BorderWidthLeft = 35;// BorderWidth;
                symbolTablesPdf.BorderWidthRight = 30;// BorderWidth;
                symbolTablesPdf.BorderWidthBottom = 20;// BorderWidth;
                symbolTablesPdf.ImageSize = ImageSize;
                symbolTablesPdf.Language = language;
                symbolTablesPdf.FontSizeName = FontSizeName;
                symbolTablesPdf.FontSizeOverlay = 7; // FontSizeOverlay;
                symbolTablesPdf.Orientation = Landscape ? PdfSharp.PageOrientation.Landscape : PdfSharp.PageOrientation.Portrait;
                symbolTablesPdf.NewPage = NewPage;

                var document = symbolTablesPdf.createPdfDocument((string)path);

                symbolTablesPdf.SymbolTablesCount_Changed -= SymbolTablesCount_Changed;
                symbolTablesPdf.SymbolImagesCount_Changed -= SymbolImagesCount_Changed;
                symbolTablesPdf.Progress_Changed -= Progress_Changed;

                savePdf(document, language);
            }
            catch (Exception ex)
            {
                OnProcess = false;
                MessageBox.Show(ex.Message, "create Pdf");
            }
        }



        private void savePdf(PdfDocument document, String language)
        {
            try
            {
                if (this.InvokeRequired)
                    this.BeginInvoke(new Action<PdfDocument, String>(savePdf), new object[] { document, language });
                else
                {
                    var sfd = new SaveFileDialog();
                    sfd.FileName = "symboltables_" + language + ".pdf";
                    sfd.Filter = "pdf files (*.pdf)|*.pdf|All files (*.*)|*.*";


                    if (sfd.ShowDialog() == DialogResult.OK)
                    {
                        if (SymbolTablesPdf.savePdfDocument(sfd.FileName, document))

                            if (ViewPdf)
                                // ...and start a viewer.
                                Process.Start(sfd.FileName);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "save Pdf");
            }

        }

        void SymbolTablesCount_Changed(object sender, EventArgs e)
        {
            if (this.InvokeRequired)
                this.BeginInvoke(new Action<object, EventArgs>(SymbolTablesCount_Changed), new object[] { sender, e });
            else if (sender is SymbolTablesPdf)
            {
                int tablesSum = 0;
                foreach (var symbolTablesPdf in activeSymbolTablesPdfs)
                    tablesSum += symbolTablesPdf.SymbolTablesCount;

                symbolTablesCount.Text = tablesSum.ToString();
            }
        }

        void SymbolImagesCount_Changed(object sender, EventArgs e)
        {
            if (this.InvokeRequired)
                this.BeginInvoke(new Action<object, EventArgs>(SymbolImagesCount_Changed), new object[] { sender, e });
            else if (sender is SymbolTablesPdf)
            {
                int imagesSum = 0;
                foreach (var symbolTablesPdf in activeSymbolTablesPdfs)
                    imagesSum += symbolTablesPdf.SymbolImagesCount;

                symbolTablesImageCount.Text = imagesSum.ToString();
            }
        }

        void Progress_Changed(object sender, EventArgs e)
        {
            if (this.InvokeRequired)
                this.BeginInvoke(new Action<object, EventArgs>(Progress_Changed), new object[] { sender, e });
            else if (sender is SymbolTablesPdf)
            {
                double progressSum = 0;
                foreach (var symbolTablesPdf in activeSymbolTablesPdfs)
                    progressSum += symbolTablesPdf.Progress;

                createProgressBar.Value = (int)(progressSum / activeSymbolTablesPdfs.Count);

                OnProcess = progressSum != activeSymbolTablesPdfs.Count*100;
            }
        }

        private void mainForm_Shown(object sender, EventArgs e)
        {
            init();
        }

        private void mainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            saveSettings();
        }

        private void init()
        {
            updateLanguageComboBox();

            BorderWidth = Properties.Settings.Default.BorderWidth;
            ImageSize = Properties.Settings.Default.ImageSize;

            if (languageComboBox.Items.Contains(Properties.Settings.Default.Language))
                Language = Properties.Settings.Default.Language;

            FontSizeName = Properties.Settings.Default.FontSizeName;
            FontSizeOverlay = Properties.Settings.Default.FontSizeOverlay;
            NewPage = Properties.Settings.Default.NewPage;
            Landscape = Properties.Settings.Default.Landscape;
            ViewPdf = Properties.Settings.Default.ViewPdf;
            CurrentProjectPath = Properties.Settings.Default.LastPath;


            //View
            languageComboBox.Text = Language;
            imageSizeUpDown.Value = ImageSize;
            newPageCheckBox.Checked = NewPage;
            landscapeCheckBox.Checked = Landscape;
            viewPdfCheckBox.Checked = ViewPdf;
            projectFolderTextBox.Text = CurrentProjectPath;
        }

        void updateLanguageComboBox()
        {
            var _path = "";

            if (!String.IsNullOrEmpty(CurrentProjectPath))
                _path = SymbolTablesPdf.languageFileDirectory(CurrentProjectPath);

            if (!String.IsNullOrEmpty(CurrentProjectPath) && System.IO.Directory.Exists(_path))
                foreach (var file in System.IO.Directory.GetFiles(_path, "*.json"))
                {
                    var language = System.IO.Path.GetFileNameWithoutExtension(file);
                    if (!languageComboBox.Items.Contains(language))
                        languageComboBox.Items.Add(language);
                }
            else
            {
                foreach (var item in Enum.GetValues(typeof(SymbolTablesPdf.LanguageEnum)))
                {
                    if (!languageComboBox.Items.Contains(item.ToString()))
                        languageComboBox.Items.Add(item.ToString());
                }
            }
        }

        private void saveSettings()
        {
            Properties.Settings.Default.BorderWidth = BorderWidth;
            Properties.Settings.Default.ImageSize = ImageSize;
            Properties.Settings.Default.Language = Language;
            Properties.Settings.Default.FontSizeName = FontSizeName;
            Properties.Settings.Default.FontSizeOverlay = FontSizeOverlay;
            Properties.Settings.Default.NewPage = NewPage;
            Properties.Settings.Default.Landscape = Landscape;
            Properties.Settings.Default.ViewPdf = ViewPdf;
            Properties.Settings.Default.LastPath = CurrentProjectPath;

            Properties.Settings.Default.Save();
        }

        private void languageComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            Language = languageComboBox.SelectedItem == null ? null : languageComboBox.SelectedItem.ToString();
        }

        private void imageSizeUpDown_ValueChanged(object sender, EventArgs e)
        {
            ImageSize = (int)imageSizeUpDown.Value;
        }

        private void newPageCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            NewPage = newPageCheckBox.Checked;
        }

        private void landscapeCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            Landscape = landscapeCheckBox.Checked;
        }

        private void viewPdfCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            ViewPdf = viewPdfCheckBox.Checked;
        }


    }
}
