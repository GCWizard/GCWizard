using System;
using System.IO;
using System.IO.Compression;

using System.Windows.Forms;

namespace ZipAssetsFolder
{
    public partial class mainForm : Form
    {
        String lastPath = @"C:\";
        String lastFile = "";

        public mainForm()
        {
            InitializeComponent();
        }

        private void zipFolderbutton_Click(object sender, EventArgs e)
        {
            var fbd = new FolderBrowserDialog();
            fbd.SelectedPath = lastPath;

            if (fbd.ShowDialog() == DialogResult.OK)
            {
                lastPath = fbd.SelectedPath;

                if (Directory.Exists(fbd.SelectedPath))
                {
                    var filename = zipFolderImages(fbd.SelectedPath);
                    MessageBox.Show(filename, "Zip Folder");
                }

            }
        }

        private void checkZipbutton_Click(object sender, EventArgs e)
        {
            zipFuncion(false);
        }

        private void reZipFilebutton_Click(object sender, EventArgs e)
        {
            zipFuncion(true);
        }

        private void zipFuncion(bool reZip)
        {
            var fod = new OpenFileDialog();
            fod.Multiselect = false;
            fod.Filter = "Zip files (*.zip)|*.zip|All files (*.*)|*.*";
            if (String.IsNullOrEmpty(lastFile))
                fod.InitialDirectory = lastPath;
            else
                fod.FileName = lastFile;

            if (fod.ShowDialog() == DialogResult.OK)
            {
                lastPath = Path.GetDirectoryName(fod.FileName);
                lastFile = fod.FileName;

                if (reZip)
                {
                    reZipFile(lastFile);
                    MessageBox.Show(lastFile, "reZip");
                }
                else
                {
                    checkStreams(lastFile);
                }
            }
        }

        private String zipFolderImages(String directory)
        {
            try
            {
                var zipFile = Path.Combine(directory, Path.GetFileName(directory) + ".zip");
                var tmpDir = Path.Combine(directory , "tmp");

                Directory.CreateDirectory(tmpDir);


                foreach (string image in Directory.GetFiles(directory, "*.png"))
                {
                    File.Move(image, Path.Combine(tmpDir, Path.GetFileName(image)));
                }

                zipFilesAndDeleteFolder(zipFile, tmpDir);

                return zipFile;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Zip Images Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            return null;
        }

        private static void zipFilesAndDeleteFolder(string zipFile, string tmpDir)
        {
            File.Delete(zipFile);
            ZipFile.CreateFromDirectory(tmpDir, zipFile);
            Directory.Delete(tmpDir, true);
        }

        private void checkStreams(String zipFile)
        {
            try
            {
                var problemFiles = "";
                var files = ZipFile.OpenRead(zipFile);
                foreach (ZipArchiveEntry entry in files.Entries)
                {
                    try
                    {
                        var stream = entry.Open();
                        if (!(stream is DeflateStream))
                            problemFiles += "\r\n" + entry.Name;
                    }
                    catch (Exception)
                    {
                        problemFiles += "\r\n" + entry.Name;
                        //MessageBox.Show(ex.Message, "Stream check Exception");
                    }
                }

                if (!String.IsNullOrEmpty(problemFiles))
                    MessageBox.Show("SubStreams found:" + problemFiles, "Stream check", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                else
                    MessageBox.Show("No SubStreams found", "Stream check");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Stream check Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }


        private void reZipFile(String zipFile)
        {
            try
            {
                var tmpDir = Path.Combine(Path.GetDirectoryName(zipFile), "tmp");
                var files = ZipFile.OpenRead(zipFile);

                Directory.CreateDirectory(tmpDir);

                try
                {
                    foreach (ZipArchiveEntry entry in files.Entries)
                    {
                        try
                        {
                            var targetPath = Path.Combine(tmpDir, entry.Name);
                            File.Delete(targetPath);

                            var stream = new FileStream(targetPath, FileMode.CreateNew);
                            entry.Open().CopyTo(stream);

                            stream.Flush();
                            stream.Dispose();
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show(ex.Message, "extract file Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                    }
                    files.Dispose();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "extract file Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                try
                {
                    zipFilesAndDeleteFolder(zipFile, tmpDir);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "zip files Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "reZip file Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

    }
}

