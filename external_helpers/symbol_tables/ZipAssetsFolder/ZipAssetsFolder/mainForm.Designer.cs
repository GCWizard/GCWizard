namespace ZipAssetsFolder
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
            this.zipFolderButton = new System.Windows.Forms.Button();
            this.checkStreamsButton = new System.Windows.Forms.Button();
            this.reZipButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // zipFolderButton
            // 
            this.zipFolderButton.Location = new System.Drawing.Point(41, 86);
            this.zipFolderButton.Name = "zipFolderButton";
            this.zipFolderButton.Size = new System.Drawing.Size(76, 48);
            this.zipFolderButton.TabIndex = 1;
            this.zipFolderButton.Text = "Zip Folder";
            this.zipFolderButton.UseVisualStyleBackColor = true;
            this.zipFolderButton.Click += new System.EventHandler(this.zipFolderbutton_Click);
            // 
            // checkStreamsButton
            // 
            this.checkStreamsButton.Location = new System.Drawing.Point(159, 86);
            this.checkStreamsButton.Name = "checkStreamsButton";
            this.checkStreamsButton.Size = new System.Drawing.Size(76, 48);
            this.checkStreamsButton.TabIndex = 2;
            this.checkStreamsButton.Text = "Check Streams";
            this.checkStreamsButton.UseVisualStyleBackColor = true;
            this.checkStreamsButton.Click += new System.EventHandler(this.checkZipbutton_Click);
            // 
            // reZipButton
            // 
            this.reZipButton.Location = new System.Drawing.Point(159, 159);
            this.reZipButton.Name = "reZipButton";
            this.reZipButton.Size = new System.Drawing.Size(76, 48);
            this.reZipButton.TabIndex = 3;
            this.reZipButton.Text = "reZip File";
            this.reZipButton.UseVisualStyleBackColor = true;
            this.reZipButton.Click += new System.EventHandler(this.reZipFilebutton_Click);
            // 
            // mainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Controls.Add(this.reZipButton);
            this.Controls.Add(this.checkStreamsButton);
            this.Controls.Add(this.zipFolderButton);
            this.Name = "mainForm";
            this.Text = "Zip Symbol-files";
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.Button zipFolderButton;
        private System.Windows.Forms.Button checkStreamsButton;
        private System.Windows.Forms.Button reZipButton;
    }
}

