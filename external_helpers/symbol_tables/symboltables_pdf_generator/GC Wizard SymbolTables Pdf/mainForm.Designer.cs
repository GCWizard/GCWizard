namespace GC_Wizard_SymbolTables_Pdf
{
    partial class mainForm
    {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent()
        {
            this.startButton = new System.Windows.Forms.Button();
            this.configGroupBox = new System.Windows.Forms.GroupBox();
            this.landscapeCheckBox = new System.Windows.Forms.CheckBox();
            this.imageSizeLabel = new System.Windows.Forms.Label();
            this.imageSizeUpDown = new System.Windows.Forms.NumericUpDown();
            this.viewPdfCheckBox = new System.Windows.Forms.CheckBox();
            this.newPageCheckBox = new System.Windows.Forms.CheckBox();
            this.languageLabel = new System.Windows.Forms.Label();
            this.languageComboBox = new System.Windows.Forms.ComboBox();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.symbolTablesCountLabel = new System.Windows.Forms.ToolStripStatusLabel();
            this.symbolTablesCount = new System.Windows.Forms.ToolStripStatusLabel();
            this.symbolTablesImageCountLabel = new System.Windows.Forms.ToolStripStatusLabel();
            this.symbolTablesImageCount = new System.Windows.Forms.ToolStripStatusLabel();
            this.createProgressBar = new System.Windows.Forms.ToolStripProgressBar();
            this.projectPathLabel = new System.Windows.Forms.ToolStripStatusLabel();
            this.projectFolderTextBox = new System.Windows.Forms.TextBox();
            this.openProjectFolderButton = new System.Windows.Forms.Button();
            this.startDefaultButton = new System.Windows.Forms.Button();
            this.configGroupBox.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.imageSizeUpDown)).BeginInit();
            this.statusStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // startButton
            // 
            this.startButton.Location = new System.Drawing.Point(12, 288);
            this.startButton.Name = "startButton";
            this.startButton.Size = new System.Drawing.Size(71, 52);
            this.startButton.TabIndex = 0;
            this.startButton.Text = "Start";
            this.startButton.UseVisualStyleBackColor = true;
            this.startButton.Click += new System.EventHandler(this.startButton_Click);
            // 
            // configGroupBox
            // 
            this.configGroupBox.Controls.Add(this.landscapeCheckBox);
            this.configGroupBox.Controls.Add(this.imageSizeLabel);
            this.configGroupBox.Controls.Add(this.imageSizeUpDown);
            this.configGroupBox.Controls.Add(this.viewPdfCheckBox);
            this.configGroupBox.Controls.Add(this.newPageCheckBox);
            this.configGroupBox.Controls.Add(this.languageLabel);
            this.configGroupBox.Controls.Add(this.languageComboBox);
            this.configGroupBox.Location = new System.Drawing.Point(12, 60);
            this.configGroupBox.Name = "configGroupBox";
            this.configGroupBox.Size = new System.Drawing.Size(379, 208);
            this.configGroupBox.TabIndex = 1;
            this.configGroupBox.TabStop = false;
            this.configGroupBox.Text = "Config";
            // 
            // landscapeCheckBox
            // 
            this.landscapeCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.landscapeCheckBox.Location = new System.Drawing.Point(37, 135);
            this.landscapeCheckBox.Name = "landscapeCheckBox";
            this.landscapeCheckBox.Size = new System.Drawing.Size(104, 24);
            this.landscapeCheckBox.TabIndex = 7;
            this.landscapeCheckBox.Text = "landscape";
            this.landscapeCheckBox.UseVisualStyleBackColor = true;
            this.landscapeCheckBox.CheckedChanged += new System.EventHandler(this.landscapeCheckBox_CheckedChanged);
            // 
            // imageSizeLabel
            // 
            this.imageSizeLabel.AutoSize = true;
            this.imageSizeLabel.Location = new System.Drawing.Point(34, 67);
            this.imageSizeLabel.Name = "imageSizeLabel";
            this.imageSizeLabel.Size = new System.Drawing.Size(56, 13);
            this.imageSizeLabel.TabIndex = 6;
            this.imageSizeLabel.Text = "image size";
            // 
            // imageSizeUpDown
            // 
            this.imageSizeUpDown.Location = new System.Drawing.Point(127, 65);
            this.imageSizeUpDown.Maximum = new decimal(new int[] {
            999,
            0,
            0,
            0});
            this.imageSizeUpDown.Minimum = new decimal(new int[] {
            10,
            0,
            0,
            0});
            this.imageSizeUpDown.Name = "imageSizeUpDown";
            this.imageSizeUpDown.Size = new System.Drawing.Size(55, 20);
            this.imageSizeUpDown.TabIndex = 5;
            this.imageSizeUpDown.Value = new decimal(new int[] {
            50,
            0,
            0,
            0});
            this.imageSizeUpDown.ValueChanged += new System.EventHandler(this.imageSizeUpDown_ValueChanged);
            // 
            // viewPdfCheckBox
            // 
            this.viewPdfCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.viewPdfCheckBox.Location = new System.Drawing.Point(37, 166);
            this.viewPdfCheckBox.Name = "viewPdfCheckBox";
            this.viewPdfCheckBox.Size = new System.Drawing.Size(104, 24);
            this.viewPdfCheckBox.TabIndex = 3;
            this.viewPdfCheckBox.Text = "view Pdf";
            this.viewPdfCheckBox.UseVisualStyleBackColor = true;
            this.viewPdfCheckBox.CheckedChanged += new System.EventHandler(this.viewPdfCheckBox_CheckedChanged);
            // 
            // newPageCheckBox
            // 
            this.newPageCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.newPageCheckBox.Location = new System.Drawing.Point(37, 105);
            this.newPageCheckBox.Name = "newPageCheckBox";
            this.newPageCheckBox.Size = new System.Drawing.Size(104, 24);
            this.newPageCheckBox.TabIndex = 2;
            this.newPageCheckBox.Text = "new page";
            this.newPageCheckBox.UseVisualStyleBackColor = true;
            this.newPageCheckBox.CheckedChanged += new System.EventHandler(this.newPageCheckBox_CheckedChanged);
            // 
            // languageLabel
            // 
            this.languageLabel.AutoSize = true;
            this.languageLabel.Location = new System.Drawing.Point(34, 20);
            this.languageLabel.Name = "languageLabel";
            this.languageLabel.Size = new System.Drawing.Size(55, 13);
            this.languageLabel.TabIndex = 1;
            this.languageLabel.Text = "Language";
            // 
            // languageComboBox
            // 
            this.languageComboBox.FormattingEnabled = true;
            this.languageComboBox.Location = new System.Drawing.Point(127, 17);
            this.languageComboBox.Name = "languageComboBox";
            this.languageComboBox.Size = new System.Drawing.Size(55, 21);
            this.languageComboBox.TabIndex = 0;
            this.languageComboBox.SelectedIndexChanged += new System.EventHandler(this.languageComboBox_SelectedIndexChanged);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.symbolTablesCountLabel,
            this.symbolTablesCount,
            this.symbolTablesImageCountLabel,
            this.symbolTablesImageCount,
            this.createProgressBar,
            this.projectPathLabel});
            this.statusStrip1.Location = new System.Drawing.Point(0, 359);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(429, 22);
            this.statusStrip1.TabIndex = 2;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // symbolTablesCountLabel
            // 
            this.symbolTablesCountLabel.Name = "symbolTablesCountLabel";
            this.symbolTablesCountLabel.Size = new System.Drawing.Size(82, 17);
            this.symbolTablesCountLabel.Text = "SymbolTables:";
            // 
            // symbolTablesCount
            // 
            this.symbolTablesCount.Name = "symbolTablesCount";
            this.symbolTablesCount.Size = new System.Drawing.Size(13, 17);
            this.symbolTablesCount.Text = "0";
            // 
            // symbolTablesImageCountLabel
            // 
            this.symbolTablesImageCountLabel.Name = "symbolTablesImageCountLabel";
            this.symbolTablesImageCountLabel.Size = new System.Drawing.Size(73, 17);
            this.symbolTablesImageCountLabel.Text = "ImageCount";
            // 
            // symbolTablesImageCount
            // 
            this.symbolTablesImageCount.Name = "symbolTablesImageCount";
            this.symbolTablesImageCount.Size = new System.Drawing.Size(13, 17);
            this.symbolTablesImageCount.Text = "0";
            // 
            // createProgressBar
            // 
            this.createProgressBar.Name = "createProgressBar";
            this.createProgressBar.Size = new System.Drawing.Size(100, 16);
            // 
            // projectPathLabel
            // 
            this.projectPathLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.projectPathLabel.AutoSize = false;
            this.projectPathLabel.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.projectPathLabel.MergeAction = System.Windows.Forms.MergeAction.Insert;
            this.projectPathLabel.MergeIndex = 5;
            this.projectPathLabel.Name = "projectPathLabel";
            this.projectPathLabel.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.projectPathLabel.Size = new System.Drawing.Size(218, 17);
            this.projectPathLabel.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // projectFolderTextBox
            // 
            this.projectFolderTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.projectFolderTextBox.Location = new System.Drawing.Point(13, 22);
            this.projectFolderTextBox.Name = "projectFolderTextBox";
            this.projectFolderTextBox.Size = new System.Drawing.Size(312, 20);
            this.projectFolderTextBox.TabIndex = 3;
            // 
            // openProjectFolderButton
            // 
            this.openProjectFolderButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.openProjectFolderButton.BackgroundImage = global::GC_Wizard_SymbolTables_Pdf.Properties.Resources.open_icon;
            this.openProjectFolderButton.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.openProjectFolderButton.Location = new System.Drawing.Point(345, 13);
            this.openProjectFolderButton.Name = "openProjectFolderButton";
            this.openProjectFolderButton.Size = new System.Drawing.Size(48, 37);
            this.openProjectFolderButton.TabIndex = 4;
            this.openProjectFolderButton.UseVisualStyleBackColor = true;
            this.openProjectFolderButton.Click += new System.EventHandler(this.openProjectFolderButton_Click);
            // 
            // startDefaultButton
            // 
            this.startDefaultButton.Location = new System.Drawing.Point(114, 288);
            this.startDefaultButton.Name = "startDefaultButton";
            this.startDefaultButton.Size = new System.Drawing.Size(71, 52);
            this.startDefaultButton.TabIndex = 5;
            this.startDefaultButton.Text = "Start all\r\nstandard\r\nlanguages";
            this.startDefaultButton.UseVisualStyleBackColor = true;
            this.startDefaultButton.Click += new System.EventHandler(this.StartDefaultButton_Click);
            // 
            // mainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(429, 381);
            this.Controls.Add(this.startDefaultButton);
            this.Controls.Add(this.openProjectFolderButton);
            this.Controls.Add(this.projectFolderTextBox);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.configGroupBox);
            this.Controls.Add(this.startButton);
            this.Name = "mainForm";
            this.Text = "create Pdf";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.mainForm_FormClosing);
            this.Shown += new System.EventHandler(this.mainForm_Shown);
            this.configGroupBox.ResumeLayout(false);
            this.configGroupBox.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.imageSizeUpDown)).EndInit();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button startButton;
        private System.Windows.Forms.GroupBox configGroupBox;
        private System.Windows.Forms.CheckBox newPageCheckBox;
        private System.Windows.Forms.Label languageLabel;
        private System.Windows.Forms.ComboBox languageComboBox;
        private System.Windows.Forms.CheckBox viewPdfCheckBox;
        private System.Windows.Forms.Label imageSizeLabel;
        private System.Windows.Forms.NumericUpDown imageSizeUpDown;
        private System.Windows.Forms.CheckBox landscapeCheckBox;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel symbolTablesCountLabel;
        private System.Windows.Forms.ToolStripStatusLabel symbolTablesCount;
        private System.Windows.Forms.ToolStripStatusLabel symbolTablesImageCountLabel;
        private System.Windows.Forms.ToolStripStatusLabel symbolTablesImageCount;
        private System.Windows.Forms.ToolStripProgressBar createProgressBar;
        private System.Windows.Forms.ToolStripStatusLabel projectPathLabel;
        private System.Windows.Forms.TextBox projectFolderTextBox;
        private System.Windows.Forms.Button openProjectFolderButton;
        private System.Windows.Forms.Button startDefaultButton;
    }
}

