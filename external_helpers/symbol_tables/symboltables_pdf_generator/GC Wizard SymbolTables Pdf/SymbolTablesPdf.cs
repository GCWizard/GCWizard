using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Diagnostics;
using System.IO;
using PdfSharp.Pdf;
using PdfSharp.Drawing;
using System.IO.Compression;

namespace GC_Wizard_SymbolTables_Pdf
{

    // dll from http://www.pdfsharp.net/
    public class SymbolTablesPdf
    {
        const string CONFIG_FILENAME = "config.file";
        const string CONFIG_SPECIALMAPPINGS = "special_mappings";
        const string CONFIG_TRANSLATE = "translate";
        const string CONFIG_CASESENSITIVE = "case_sensitive";
        const string CONFIG_TRANSLATIONPREFIX = "translation_prefix";
        const string CONFIG_SPECIALSORT = "special_sort";
        const string CONFIG_IGNORE = "ignore";
        const string CONFIG_DefaultFont = "Verdana";
        string CONFIG_Font = CONFIG_DefaultFont;
        const bool testPage = false;

        struct SymbolInfo
        {
            public Stream Stream;
            public string Overlay;

            public SymbolInfo(Stream stream, string overlay)
            {
                Stream = stream;
                Overlay = overlay;
            }
        }

        public EventHandler SymbolTablesCount_Changed;

        public EventHandler SymbolImagesCount_Changed;

        public EventHandler Progress_Changed;

        private String versionText = "";

        public Single BorderWidthTop { get; set; }
        public Single BorderWidthLeft { get; set; }
        public Single BorderWidthRight { get; set; }
        public Single BorderWidthBottom { get; set; }

        public int ImageSize { get; set; }


        public int HeadingDistance { get; set; }
        public int RowDistance { get; set; }
        public int ColumnDistance { get; set; }

        public String Language { get; set; }

        public double FontSizeName { get; set; }

        public double FontSizeOverlay { get; set; }

        public bool NewPage { get; set; }

        public PdfSharp.PageOrientation Orientation { get; set; }

        private PdfOutline Outline { get; set; }
        private String ProjectPath { get; set; }


        private double _Progress = 0;
        public double Progress
        {
            get
            {
                return _Progress;
            }
            internal set
            {
                if (_Progress != value)
                {
                    _Progress = value;
                    Progress_Changed?.Invoke(this, EventArgs.Empty);
                }
            }
        }

        private int _SymbolTablesCount = 0;
        public int SymbolTablesCount
        {
            get
            {
                return _SymbolTablesCount;
            }
            internal set
            {
                if (_SymbolTablesCount != value)
                {
                    _SymbolTablesCount = value;
                    SymbolTablesCount_Changed?.Invoke(this, EventArgs.Empty);
                }
            }
        }

        private int _SymbolImagesCount = 0;
        public int SymbolImagesCount
        {
            get
            {
                return _SymbolImagesCount;
            }
            internal set
            {
                if (_SymbolImagesCount != value)
                {
                    _SymbolImagesCount = value;
                    SymbolImagesCount_Changed?.Invoke(this, EventArgs.Empty);
                }
            }
        }

        private Dictionary<String, String> CONFIG_SPECIAL_CHARS = null;


        private XImage _GcwIcon;
        // GC Wicard Icon
        private XImage GcwIcon
        {
            get
            {
                if (_GcwIcon == null)
                {
                    MemoryStream memoryStream = new MemoryStream();
                    Properties.Resources.circle_border_128.Save(memoryStream, System.Drawing.Imaging.ImageFormat.Png);
                    _GcwIcon = XImage.FromGdiPlusImage(Image.FromStream(memoryStream));
                }
                return _GcwIcon;
            }
        }

        private bool FontEmbeded { get; set; }
        private List<XFont> FontList { get; set; } = new List<XFont>();


        public enum LanguageEnum
        {
            de,
            en
        }

        public SymbolTablesPdf()
        {
            HeadingDistance = 10;
            RowDistance = 18;
            ColumnDistance = 10;

            BorderWidthTop = 35;
            BorderWidthLeft = 35;
            BorderWidthRight = 20;
            BorderWidthBottom = 20;
            ImageSize = 50;
            Language = "de";
            FontSizeName = 20;
            FontSizeOverlay = 8;
            Orientation = PdfSharp.PageOrientation.Portrait;
        }

        public PdfDocument createPdfDocument(String path)
        {
            try
            {
                // Create a new PDF document
                PdfDocument document = new PdfDocument();
                document.Info.Title = "GC Wizard Symbol Tables";

                drawSymbolTables(path, document);

                return document;
            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        /// Save the document...
        /// </summary>
        /// <param name="path"></param>
        public static bool savePdfDocument(String path, PdfDocument document)
        {
            try
            {
                if (String.IsNullOrEmpty(path) || (document == null))
                    return false;

                document.Save(path);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            return true;
        }

        /// <summary>
        /// draw all symbol tables
        /// </summary>
        /// <param name="path"></param>
        /// <param name="document"></param>
        private void drawSymbolTables(String path, PdfDocument document)
        {
            PointF offset;
            var languagefile = File.ReadAllText(languageFileName(path));
            var languagefileEn = File.ReadAllText(languageFileNameEn(path));
            var licenseEntries = getLicenseEntries(File.ReadAllText(licenseFileName(path)));

            ProjectPath = path;
            PdfPage page = null;
            // Get an XGraphics object for drawing
            XGraphics gfx = null;
            Progress = 0;

            // Create the root bookmark. You can set the style and the color.
            var config = getContentTableName();
            var contentTableName = config.Item1;
            CONFIG_Font = config.Item2;
            offset = createPage(document, ref page, ref gfx);

            Outline = document.Outlines.Add(contentTableName, page, true, PdfOutlineStyle.Bold, XColors.Black);

            var directorys = createDirectoryList(path, languagefile, languagefileEn);
            var progress_offset = directorys.Any() ? (100.0 / directorys.Count()) : 100;
            foreach (var entry in directorys)
            {
                //Debug.Print(entry.Value);
                offset = drawSymbolTable(path, entry.Value, entry.Key, document, ref page, ref gfx, offset, languagefile, languagefileEn, licenseEntries);

                offset.X = BorderWidthLeft;
                offset.Y += ImageSize + 20;

                Progress += progress_offset;
            }

            drawLicenses(document, ref page, ref gfx, offset, languagefile, licenseEntries);

            Progress = 100;
        }

        #region symbol table

        /// <summary>
        /// draw complete symbol table
        /// </summary>
        /// <param name="path"></param>
        /// <param name="name"></param>
        /// <param name="folder"></param>
        /// <param name="document"></param>
        /// <param name="page"></param>
        /// <param name="gfx"></param>
        /// <param name="offset"></param>
        /// <param name="languagefile">language file</param>
        /// <param name="languagefileEn">english language file (backup)</param>
        /// <param name="licenseEntries"></param>
        /// <returns></returns>
        private PointF drawSymbolTable(String path, String name, String folder, PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset, String languagefile, String languagefileEn, Dictionary<string, string> licenseEntries)
        {
            var description = getEntryValue(languagefile, "symboltables_" + folder + "_description");
            var license = "";
            if (licenseEntries.ContainsKey(folder))
            {
                var sourceLabel = getSourceLabel();
                license = "(" + sourceLabel + ": " + licenseEntries[folder] + ")";
            }

            if (name == null)
                name = folder;

            var symbolList = createSymbolList(path, folder, languagefile, languagefileEn);
            offset = drawName(name, description, license, symbolList.Count(), document, ref page, ref gfx, offset);
            SymbolTablesCount += 1;

            foreach (var symbol in symbolList)
            {
                offset = drawImage(symbol.Value.Stream, document, ref page, ref gfx, offset, symbol.Value.Overlay);
                SymbolImagesCount += 1;
                symbol.Value.Stream.Dispose();
            }

            return offset;
        }

        /// <summary>
        /// create list with symbols and overlay
        /// </summary>
        /// <param name="path"></param>
        /// <param name="_symbolKey"></param>
        /// <param name="languagefile">language file</param>
        /// <param name="languagefileEn">english language file (backup)</param>
        /// <returns></returns>
        private IEnumerable<KeyValuePair<String, SymbolInfo>> createSymbolList(String path, String _symbolKey, String languagefile, String languagefileEn)
        {
            var list = new Dictionary<String, SymbolInfo>();
            var overlay = String.Empty;
            var _path = symbolTablesDirectory(path);
            _path = Path.Combine(_path, _symbolKey);

            var configFilePath = Path.Combine(_path, CONFIG_FILENAME);
            List<String> translateList = null;
            List<String> translateables = null;
            List<String> ignoreList = null;
            Dictionary<String, String> mappingList = null;
            bool caseSensitive = false;
            bool specialSort = false;
            String translationPrefixConfig = null;

            if (File.Exists(Path.Combine(configFilePath)))
            {
                var fileContent = File.ReadAllText(configFilePath);
                translateList = parseTranslateConfig(fileContent);
                translateables = new List<String>();
                ignoreList = parseIgnoreConfig(fileContent);
                mappingList = parseMappingConfig(fileContent);
                caseSensitive = parseCaseSensitiveConfig(fileContent);
                specialSort = parseSpecialSortConfig(fileContent);
                translationPrefixConfig = parseTranslationPrefixConfig(fileContent);
            }
            else
                mappingList = parseMappingConfig(null);

            foreach (string zipFile in Directory.GetFiles(_path, "*.zip"))
            {
                var files = ZipFile.OpenRead(zipFile);
                foreach (ZipArchiveEntry entry in files.Entries)
                {
                    if (entry.FullName.EndsWith(".png", StringComparison.OrdinalIgnoreCase))
                    {
                        var symbol = entry.FullName;
                        if (ignoreList == null || ignoreList.Count == 0 || !ignoreList.Contains(Path.GetFileNameWithoutExtension(symbol)))
                        {
                            overlay = symbolOverlay(symbol, _symbolKey, languagefile, languagefileEn, translateList, mappingList, caseSensitive, ref translateables, translationPrefixConfig);
                            var stream = new MemoryStream();
                            entry.Open().CopyTo(stream);

                            list.Add(symbol, new SymbolInfo(stream, overlay));
                        }
                    }
                }
                break; // first zip-file
            }

            Comparer<object> _sort;
            if (specialSort == false)
            {
                _sort = new NameSort(translateables);
            }
            else
            {
                switch (_symbolKey)
                {
                    case "notes_names_altoclef": _sort = new specialSortNoteNames(translateables); break;
                    case "notes_names_bassclef": _sort = new specialSortNoteNames(translateables); break;
                    case "notes_names_trebleclef": _sort = new specialSortNoteNames(translateables); break;
                    case "notes_notevalues": _sort = new specialSortNoteValues(translateables); break;
                    case "notes_restvalues": _sort = new specialSortNoteValues(translateables); break;
                    case "trafficsigns_germany": _sort = new specialSortTrafficSignsGermany(translateables); break;
                    default: _sort = new NameSort(translateables); break;
                }
            }

            var listSorted = list.ToList();
            if (_sort is specialSortNoteNames || _sort is specialSortNoteValues)
                listSorted.Sort(delegate (KeyValuePair<String, SymbolInfo> x, KeyValuePair<String, SymbolInfo> y) { return _sort.Compare(x.Key, y.Key); });
            else
                listSorted.Sort(delegate (KeyValuePair<String, SymbolInfo> x, KeyValuePair<String, SymbolInfo> y) { return _sort.Compare(x.Value, y.Value); });

            return listSorted;
        }

        #endregion

        #region draw pdf pages

        /// <summary>
        /// draw symbol table header
        /// </summary>
        /// <param name="name"></param>
        /// <param name="description"></param>
        /// <param name="license"></param>
        /// <param name="count"></param>
        /// <param name="document"></param>
        /// <param name="page"></param>
        /// <param name="gfx"></param>
        /// <param name="offset"></param>
        /// <returns></returns>
        private PointF drawName(String name, string description, string license, int count, PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset)
        {
            // Create a font
            XFont font = CreateXFont(CONFIG_Font, FontSizeName, XFontStyle.BoldItalic);

            var name_offset = font.Height;
            if (!string.IsNullOrEmpty(description))
                name_offset += font.Height / 2;
            if (!string.IsNullOrEmpty(license))
                name_offset += font.Height / 4;

            name_offset += 20;

            if (page == null || NewPage)
                offset = createPage(document, ref page, ref gfx);
            else if (offset.Y + name_offset + (ImageSize + RowDistance) > page.Height - BorderWidthBottom)
            {
                if (count > rowImageCount(ref page))
                    offset = createPage(document, ref page, ref gfx);
            }
            else if (offset.Y + name_offset + 2 * (ImageSize + RowDistance) > page.Height - BorderWidthBottom)
            {
                if (count > 2 * rowImageCount(ref page))
                    offset = createPage(document, ref page, ref gfx);
            }

            // Draw the name
            gfx.DrawString(name, font, XBrushes.Black,
            new XRect(offset.X, offset.Y, page.Width, page.Height),
            XStringFormats.TopLeft);

            offset.Y += font.Height;

            // description
            if (!string.IsNullOrEmpty(description))
            {
                font = CreateXFont(CONFIG_Font, FontSizeName / 2, XFontStyle.Regular);

                // Draw the description
                gfx.DrawString(description, font, XBrushes.Black,
                new XRect(offset.X, offset.Y, page.Width, page.Height),
                XStringFormats.TopLeft);

                offset.Y += font.Height;
            }

            // license
            if (!string.IsNullOrEmpty(license))
            {
                font = CreateXFont(CONFIG_Font, FontSizeName / 4, XFontStyle.Regular);

                // Draw the license
                gfx.DrawString(license, font, XBrushes.Black,
                new XRect(offset.X, offset.Y, page.Width, page.Height),
                XStringFormats.TopLeft);

                offset.Y += font.Height;
            }
            offset.Y += HeadingDistance;

            Outline.Outlines.Add(name, page, true);

            return offset;
        }


        /// <summary>
        /// draw symbol overlay text
        /// </summary>
        /// <param name="name"></param>
        /// <param name="maxLength"></param>
        /// <param name="document"></param>
        /// <param name="page"></param>
        /// <param name="gfx"></param>
        /// <param name="offset"></param>
        /// <returns></returns>
        private PointF drawOverlay(String name, int maxLength, PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset)
        {
            // Create a font
            XFont font = CreateXFont(CONFIG_Font, FontSizeOverlay, XFontStyle.Regular);
            if (name == " ")
            {
                drawSpaceSymbol(offset, XColors.Blue, font, gfx);
                return offset;
            }

            // Draw the name
            name = checkTextLength(name, maxLength, font, gfx);
            if (!name.Contains(Environment.NewLine))
                gfx.DrawString(name, font, XBrushes.Blue, new XRect(offset.X, offset.Y, ImageSize, 2 * FontSizeOverlay), XStringFormats.TopLeft);
            else
            {
                var text = name.Split('\n');

                for (int i = 0; i < text.Length; i++)
                {
                    text[i] = text[i].Replace("\r", "");
                    gfx.DrawString(text[i], font, XBrushes.Blue, new XRect(offset.X, offset.Y + i * FontSizeOverlay, ImageSize, RowDistance), XStringFormats.TopLeft);
                }
            }

            return offset;
        }

        /// <summary>
        /// draw space symbol
        /// </summary>
        /// <param name="position"></param>
        /// <param name="color"></param>
        /// <param name="font"></param>
        /// <param name="gfx"></param>
        private void drawSpaceSymbol(PointF position, XColor color, XFont font, XGraphics gfx)
        {
            var size = gfx.MeasureString("M", font);
            var pen = new XPen(color, 1);

            gfx.DrawLine(pen, new XPoint(position.X, position.Y + size.Height), new XPoint(position.X + size.Width, position.Y + size.Height));
            gfx.DrawLine(pen, new XPoint(position.X, position.Y + size.Height), new XPoint(position.X, position.Y + size.Height * 0.8));
            gfx.DrawLine(pen, new XPoint(position.X + size.Width, position.Y + size.Height), new XPoint(position.X + size.Width, position.Y + size.Height * 0.8));

        }

        /// <summary>
        /// draw symbol image
        /// </summary>
        /// <param name="symbolStream"></param>
        /// <param name="document"></param>
        /// <param name="page"></param>
        /// <param name="gfx"></param>
        /// <param name="offset"></param>
        /// <param name="overlay"></param>
        /// <returns></returns>
        private PointF drawImage(Stream symbolStream, PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset, String overlay)
        {
            XImage image = XImage.FromGdiPlusImage(Image.FromStream(symbolStream));
            XSize size = image.Size;
            var ImageScale = ImageSize / size.Height;
            size.Width *= ImageScale;
            size.Height *= ImageScale;

            if (page == null)
                offset = createPage(document, ref page, ref gfx);
            else if (offset.X + size.Width > page.Width - BorderWidthRight)
            {
                // new Row
                offset.X = BorderWidthLeft;
                offset.Y += (Single)size.Height + RowDistance;
            }

            if (offset.Y + size.Height > page.Height - BorderWidthBottom)
                offset = createPage(document, ref page, ref gfx);

            gfx.DrawImage(image, offset.X, offset.Y, size.Width, size.Height);
            image.Dispose();

            // Border
            gfx.DrawRectangle(new XPen(XColor.FromArgb(Color.Gray.ToArgb()), 0.2), offset.X, offset.Y, size.Width, size.Height);

            // Draw the overlay
            drawOverlay(overlay, (int)(size.Width + ColumnDistance - 2), document, ref page, ref gfx, new PointF(offset.X, (Single)(offset.Y + size.Height)));

            offset.X += (Single)size.Width + ColumnDistance;

            return offset;
        }

        /// <summary>
        /// draw licenses text
        /// </summary>
        /// <param name="document"></param>
        /// <param name="page"></param>
        /// <param name="gfx"></param>
        /// <param name="offset"></param>
        /// <param name="languagefile"></param>
        /// <param name="licenseEntries"></param>
        private void drawLicenses(PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset, String languagefile, Dictionary<string, string> licenseEntries)
        {
            var licenseLabel = getLicenseLabel(languagefile);

            // Create a font
            XFont font = CreateXFont(CONFIG_Font, FontSizeName, XFontStyle.BoldItalic);
            offset = createPage(document, ref page, ref gfx);


            gfx.DrawString(licenseLabel, font, XBrushes.Black,
                new XRect(offset.X, offset.Y, page.Width, page.Height),
                XStringFormats.TopLeft);
            Outline = document.Outlines.Add(licenseLabel, page, true, PdfOutlineStyle.Bold, XColors.Black);

            var name_offset = font.Height;
            name_offset += 20;

            offset.Y += name_offset;

            // Create a font
            font = CreateXFont(CONFIG_Font, FontSizeName / 2, XFontStyle.Regular);

            double maxSize = 0;

            foreach (var entry in licenseEntries)
            {
                var name = getSymbolTableName(entry.Key, languagefile);
                var size = gfx.MeasureString(name + ":", font);
                if (maxSize < size.Width)
                    maxSize = size.Width;
            }
            var valueOffsetX = offset.X + maxSize + 10;
            var maxLength = (int)(page.Width - BorderWidthRight - valueOffsetX);

            foreach (var entry in licenseEntries)
            {
                if (newPageNeeded(page, offset, font.Height + 1))
                {
                    offset = createPage(document, ref page, ref gfx);
                }

                var name = getSymbolTableName(entry.Key, languagefile);
                if (name != null)
                {
                    gfx.DrawString(name + ":", font, XBrushes.Black,
                        new XRect(offset.X, offset.Y, page.Width, page.Height),
                        XStringFormats.TopLeft);

                    var textValues = entry.Value.Replace("\\n", "\n").Split('\n');
                    var text = new List<String>();
                    foreach (var item in textValues)
                    {
                        var values = checkTextLength(item.Replace("\r", ""), maxLength, font, gfx);
                        text.AddRange(values.Split('\n'));
                    }

                    for (int i = 0; i < text.Count; i++)
                    {
                        gfx.DrawString(text[i], font, XBrushes.Black,
                            new XRect(valueOffsetX, offset.Y, page.Width, page.Height),
                            XStringFormats.TopLeft);

                        offset.Y += font.Height + ((i == text.Count - 1) ? 1 : 0);
                    }
                }

            }

        }

        #endregion

        #region methods

        /// <summary>
        /// new page needed ?
        /// </summary>
        /// <param name="page"></param>
        /// <param name="offset"></param>
        /// <param name="name_offset"></param>
        /// <returns></returns>
        private bool newPageNeeded(PdfPage page, PointF offset, int name_offset)
        {
            // min. 2 image rows
            return (offset.Y + name_offset + HeadingDistance + 2 * ImageSize + RowDistance > page.Height - BorderWidthBottom);
        }

        /// <summary>
        /// create a new pdf page (draw header)
        /// </summary>
        /// <param name="document"></param>
        /// <param name="page"></param>
        /// <param name="gfx"></param>
        /// <returns></returns>
        private PointF createPage(PdfDocument document, ref PdfPage page, ref XGraphics gfx)
        {
            // Create a font
            XFont font = CreateXFont(CONFIG_Font, FontSizeOverlay, XFontStyle.Regular);
            XSize textSize;
            String text;

            page = document.AddPage();
            page.Orientation = Orientation;
            gfx = XGraphics.FromPdfPage(page);

            if (document.PageCount == 1)
            {
                text = File.ReadAllText(versionFileName(ProjectPath));
                versionText = getVersionEntryValue(text, "version");
            }

            textSize = gfx.MeasureString(versionText, font);
            // draw the version text
            gfx.DrawString(versionText, font, XBrushes.Black,
                    new XRect(page.Width - BorderWidthRight - textSize.Width, (BorderWidthTop - font.Height) / 2, page.Width, page.Height),
                    XStringFormats.TopLeft);

            // GC Wicard Icon
            gfx.DrawImage(GcwIcon, 5, 5, BorderWidthTop - 5, BorderWidthTop - 5);

            // Draw GC Wizard Text
            // Create a font
            font = CreateXFont(CONFIG_Font, FontSizeName / 2, XFontStyle.Regular);

            gfx.DrawString("GC Wizard", font, XBrushes.Black,
                new XRect(BorderWidthTop + 3, (BorderWidthTop - font.Height) / 2, page.Width, page.Height),
                XStringFormats.TopLeft);

            return new PointF(BorderWidthLeft, BorderWidthTop);
        }

        /// <summary>
        /// wrap text if too long 
        /// </summary>
        /// <param name="text"></param>
        /// <param name="maxLength"></param>
        /// <param name="font"></param>
        /// <param name="gfx"></param>
        /// <returns></returns>
        private static string checkTextLength(string text, int maxLength, XFont font, XGraphics gfx)
        {
            text = checkPartTextLength(text, maxLength, font, gfx);
            var index = text.LastIndexOf("\n");

            if (index >= 0)
            {
                var subString = text.Substring(index);
                var size = gfx.MeasureString(subString, font);
                while (size.Width > maxLength)
                {
                    subString = checkPartTextLength(subString, maxLength, font, gfx);

                    text = text.Substring(0, index) + subString;

                    index = text.LastIndexOf("\n") + 1;
                    subString = text.Substring(index);
                    size = gfx.MeasureString(subString, font);
                }
            }
            return text;
        }

        /// <summary>
        /// wrap text if too long
        /// </summary>
        /// <param name="text"></param>
        /// <param name="maxLength"></param>
        /// <param name="font"></param>
        /// <param name="gfx"></param>
        /// <returns></returns>
        private static string checkPartTextLength(string text, int maxLength, XFont font, XGraphics gfx)
        {
            var size = gfx.MeasureString(text, font);

            if (size.Width <= maxLength)
                return text;

            Func<string, Char, int> textSplit = (_text, _char) =>
            {
                var _index = text.LastIndexOf(_char);
                while (_index > 0)
                {
                    size = gfx.MeasureString(text.Substring(0, _index), font);
                    if (size.Width <= maxLength)
                        return _index;
                    else
                    {
                        do
                        {
                            _index = text.LastIndexOf(_char, _index - 1, _index - 1);
                            if (_index > 0)
                                size = gfx.MeasureString(text.Substring(0, _index), font);

                        } while (_index > 0 & size.Width >= maxLength);
                    }
                }
                return _index;
            };

            var index = textSplit(text, ' ');
            if (index > 1)
                return text.Substring(0, index) + Environment.NewLine + text.Substring(index).Trim();

            index = textSplit(text, '/');
            if (index > 0)
                return text.Substring(0, index) + Environment.NewLine + text.Substring(index).Trim();

            index = textSplit(text, ',');
            if (index > 0)
                return text.Substring(0, index) + Environment.NewLine + text.Substring(index).Trim();

            index = textSplit(text, ')');
            if (index > 0)
                return text.Substring(0, index) + Environment.NewLine + text.Substring(index).Trim();

            for (index = text.Length - 1; index >= 0; index--)
            {
                size = gfx.MeasureString(text.Substring(0, index), font);
                if (size.Width <= maxLength)
                    return text.Substring(0, index) + Environment.NewLine + text.Substring(index);
            }

            return text;
        }

        /// <summary>
        /// calc images per row 
        /// </summary>
        /// <param name="page"></param>
        /// <returns></returns>
        int rowImageCount(ref PdfPage page)
        {
            return (int)Math.Floor((page.Width - BorderWidthLeft - BorderWidthRight) / (ImageSize + ColumnDistance));
        }

        private XFont CreateXFont(String familyName, double emSize, XFontStyle style)
        {
            var xFont = FontList.Where(font => (font.Name == familyName) & (font.Size == emSize) & (font.Style == style)).FirstOrDefault();

            if (xFont != null) return xFont;

            // Set font encoding to unicode always
            XPdfFontOptions options = new XPdfFontOptions(PdfFontEncoding.Unicode, PdfFontEmbedding.Always);

            xFont =  new XFont(familyName, emSize, style, FontEmbeded ? options : null);

            FontList.Add(xFont);
            return xFont;
        }

        #endregion

        #region parse config file

        private List<String> parseTranslateConfig(String fileContent)
        {
            var regex = new Regex(@"(" + CONFIG_TRANSLATE + @")(.*?)(\[)(.*?)(\])", RegexOptions.Singleline | RegexOptions.IgnoreCase);
            var regex2 = new Regex(@"\""(.*?)\""");
            var list = new List<String>();

            if (fileContent != null)
            {
                var match = regex.Match(fileContent);
                if (match.Success)
                {
                    var matches = regex2.Matches(match.Groups[4].Value);
                    foreach (Match match2 in matches)
                        list.Add(match2.Groups[1].Value);
                }
            }
            return list;
        }

        private Dictionary<String, String> parseMappingConfig(String fileContent)
        {
            var regex = new Regex(@"(" + CONFIG_SPECIALMAPPINGS + @")(.*?)(\{)(.*?)(\})", RegexOptions.Singleline | RegexOptions.IgnoreCase);
            var regex2 = new Regex(@"\""(.*?)\""(\s*:\s*)\""(.*?)\""");
            var list = defaultMappingList();

            if (fileContent != null)
            {
                var match = regex.Match(fileContent);
                if (match.Success)
                {
                    foreach (string line in match.Groups[4].Value.Split('\n'))
                    {
                        var match2 = regex2.Match(line);
                        if (match2.Success)
                        {
                            list[match2.Groups[1].Value] = match2.Groups[3].Value;
                        }
                    }
                }
            }
            return list;
        }

        private List<String> parseIgnoreConfig(String fileContent)
        {
            var regex = new Regex(@"(" + CONFIG_IGNORE + @")(.*?)(\[)(.*?)(\])", RegexOptions.Singleline | RegexOptions.IgnoreCase);
            var regex2 = new Regex(@"\""(.*?)\""");
            var list = new List<String>();

            if (fileContent != null)
            {
                var match = regex.Match(fileContent);
                if (match.Success)
                {
                    var matches = regex2.Matches(match.Groups[4].Value);
                    foreach (Match match2 in matches)
                        list.Add(match2.Groups[1].Value);
                }
            }
            return list;
        }

        private Dictionary<String, String> defaultMappingList()
        {
            if (CONFIG_SPECIAL_CHARS == null)
            {
                CONFIG_SPECIAL_CHARS = new Dictionary<String, String>();

                var path = Path.Combine(ProjectPath, @"lib/tools/symbol_tables/_common/logic/common_symbols.dart");
                if (File.Exists(path))
                {
                    try
                    {
                        var fileContent = File.ReadAllText(path);
                        var regex = new Regex(@"(_COMMON_SYMBOLS)(.*?)(\{)(.*?)(\};)", RegexOptions.Singleline | RegexOptions.IgnoreCase);
                        var regex2 = new Regex(@"\""(.*?)\""(\s*:\s*)\""(.*?)\""");
                        var regex3 = new Regex(@"\""(.*?)\""(\s*:\s*)\""(.*?)\""{2}");

                        var match = regex.Match(fileContent);
                        if (match.Success)
                        {
                            foreach (string line in match.Groups[4].Value.Split('\n'))
                            {
                                var match2 = regex2.Match(line);
                                var match3 = regex3.Match(line);
                                if (match2.Success)
                                {
                                    var value = match2.Groups[3].Value;
                                    if (match3.Success)
                                    {
                                        value += "\"";
                                        if (value.StartsWith("\\"))
                                            value = value.Substring(1);
                                    }

                                    if (value.StartsWith("\\\\") || value.StartsWith("\\$"))
                                        //if (value == "\"")
                                        //    value = "\"";
                                        //else
                                        value = value.Substring(1);

                                    CONFIG_SPECIAL_CHARS.Add(match2.Groups[1].Value, value);
                                }
                            }
                        }
                    }
                    catch (Exception)
                    {
                    }
                }
            }
            return new Dictionary<String, String>(CONFIG_SPECIAL_CHARS);
        }

        private bool parseCaseSensitiveConfig(String fileContent)
        {
            var regex = new Regex(@"(\""" + CONFIG_CASESENSITIVE + @"\""\s *:)\s(true)");
            bool value = false;

            if (fileContent != null)
            {
                var match = regex.Match(fileContent);
                value = match.Success;
            }
            return value;
        }

        private bool parseSpecialSortConfig(String fileContent)
        {
            var regex = new Regex(@"(\""" + CONFIG_SPECIALSORT + @"\""\s *:)\s(true)");
            bool value = false;

            if (fileContent != null)
            {
                var match = regex.Match(fileContent);
                value = match.Success;
            }
            return value;
        }

        private String parseTranslationPrefixConfig(String fileContent)
        {
            return getEntryValue(fileContent, CONFIG_TRANSLATIONPREFIX);
        }

        #endregion

        #region parse source files

        /// <summary>
        /// get text from language-file
        /// </summary>
        /// <param name="fileContent"></param>
        /// <param name="entry"></param>
        /// <returns></returns>
        private static String getEntryValue(String fileContent, String entry)
        {
            var regex = new Regex(@"(""" + entry + @"""\s*:\s*)\""(.*?)\""");
            String value = null;

            foreach (string line in fileContent.Split('\n'))
            {
                var match = regex.Match(line);
                if (match.Success)
                {
                    value = match.Groups[2].Value;
                    break;
                }
            }

            return value;
        }

        /// <summary>
        /// get text from version-file
        /// </summary>
        /// <param name="fileContent"></param>
        /// <param name="entry"></param>
        /// <returns></returns>
        private static String getVersionEntryValue(String fileContent, String entry)
        {
            var regex = new Regex(@"(" + entry + @":)(.*?)(\+)(.*?)(\r)");
            String value = null;

            foreach (string line in fileContent.Split('\n'))
            {
                var match = regex.Match(line);
                if (match.Success)
                {
                    value = "Version: " + match.Groups[2].Value + " (Build: " + match.Groups[4].Value + ")";
                    break;
                }
            }

            return value;
        }

        /// <summary>
        /// get text from license-file
        /// </summary>
        /// <param name="fileContent"></param>
        /// <returns></returns>
        private Dictionary<String, String> getLicenseEntries(String fileContent)
        {
            var start = false;
            var startChildren = false;
            var list = new Dictionary<String, String>();
            var lines = fileContent.Split('\n');

            for (var i = 0; i < lines.Length - 1; i++)
            {
                var line = lines[i].Trim();
                if (line.StartsWith("[") && startChildren)
                {
                    while (!(line.EndsWith("],") || line.EndsWith("]")))
                    {
                        i++;
                        line += lines[i].Trim();
                    };
                }

                if (!start && line.Contains(@"licenses_symboltablesources"))
                {
                    start = true;
                }
                //else if (!start && line.Contains(@"licenses_telegraphs"))
                //{
                //    start = true;
                //}
                else if (start && !startChildren && line.Contains(@"GCWColumnedMultilineOutput"))
                {
                    startChildren = true;
                }
                else if (startChildren && line.TrimStart().StartsWith(@"["))
                {
                    var lineTmp = line.Trim();
                    lineTmp = lineTmp.Replace("[", "").Replace("]", "").Replace("'", "");
                    var entrys = lineTmp.Split(',');
                    if (entrys.Length >= 2)
                    {
                        if (entrys[0].Trim() == "i18n(context")
                        {
                            entrys[1] = entrys[1].Trim();
                            if (entrys[1].EndsWith(@")"))
                                entrys[1] = entrys[1].Substring(0, entrys[1].Length - 1);

                            entrys[1] = entrys[1].Replace("symboltables_", "");
                            entrys[1] = entrys[1].Replace("_title", "");
                            entrys[0] = entrys[2].Trim();
                        }
                        entrys[0] = entrys[0].Trim();
                        entrys[1] = entrys[1].Trim().ToLower();

                        if (list.ContainsKey(entrys[1]))
                            list[entrys[1]] += ", " + entrys[0];
                        else
                            list[entrys[1]] = entrys[0];
                    }
                }
                else if (startChildren && line.Trim() == (@"),"))
                {
                    start = false;
                    startChildren = false;
                }
            }

            return list;
        }

        #endregion

        #region folder

        /// <summary>
        ///  list of symbol-tables directorys
        /// </summary>
        /// <param name="path"></param>
        /// <param name="languagefile">language file</param>
        /// <param name="languagefileEn">english language file (backup)</param>
        /// <returns></returns>
        private IEnumerable<KeyValuePair<String, String>> createDirectoryList(String path, String languagefile, String languagefileEn)
        {
            var list = new Dictionary<String, String>();
            foreach (var directory in Directory.GetDirectories(symbolTablesDirectory(path)))
            {
                var folder = @directory.Substring(directory.LastIndexOf(Path.DirectorySeparatorChar) + 1);
                var name = getSymbolTableName(folder, languagefile) ?? getSymbolTableName(folder, languagefileEn);

                if (name != null && directory != "backlog")
                    list.Add(folder, name);
            }

            var query = list.OrderBy(entry => entry.Value);
            if (testPage) return query.Take(1);

            return query;
        }


        /// <summary>
        /// language file exists ?
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public bool validFolder(String path)
        {
            if (!Directory.Exists(languageFileDirectory(path)))
                return false;
            if (!File.Exists(languageFileName(path)))
                return false;

            if (!Directory.Exists(symbolTablesDirectory(path)))
                return false;

            return true;
        }

        public static String languageFileDirectory(String path)
        {
            return Path.Combine(path, @"lib\application\i18n\assets");
        }

        private String languageFileName(String path)
        {
            return Path.Combine(languageFileDirectory(path), Language + @".json");
        }

        private String languageFileNameEn(String path)
        {
            return Path.Combine(languageFileDirectory(path), "en" + @".json");
        }

        private static String versionFileName(String path)
        {
            return Path.Combine(path, "pubspec.yaml");
        }


        private static String licenseFileName(String path)
        {
            return Path.Combine(path, @"lib\application\main_menu\licenses.dart");
        }

        private static String symbolTablesDirectory(String path)
        {
            return Path.Combine(path, @"lib\tools\symbol_tables\_common\assets");
        }

        #endregion


        #region get translations

        /// <summary>
        /// Determine symbol overlay
        /// </summary>
        /// <param name="symbolPath"></param>
        /// <param name="folder"></param>
        /// <param name="languagefile">language file</param>
        /// <param name="languagefileEn">english language file (backup)</param>
        /// <param name="translateList"></param>
        /// <param name="mappingList"></param>
        /// <param name="caseSensitive"></param>
        /// <param name="translateables"></param>
        /// <param name="translationPrefix"></param>
        /// <returns></returns>
        private String symbolOverlay(String symbolPath, String folder, String languagefile, String languagefileEn, List<String> translateList, Dictionary<String, String> mappingList, bool caseSensitive, ref List<String> translateables, String translationPrefix)
        {
            var fileName = Path.GetFileNameWithoutExtension(symbolPath);
            var overlay = fileName;

            overlay = new Regex("(^_*|_*$)").Replace(overlay, "");

            if (mappingList != null && mappingList.ContainsKey(overlay))
                overlay = mappingList[overlay];
            else if (translateList != null && translateList.Contains(overlay))
            {
                var entry = translationPrefix + overlay;
                if (String.IsNullOrEmpty(translationPrefix))
                {
                     entry = "symboltables_" + folder + "_" + overlay;
                }
                overlay = getEntryValue(languagefile, entry) ?? getEntryValue(languagefileEn, entry) ?? overlay;
                translateables.Add(overlay);
            }

            if (!caseSensitive)
                overlay = overlay.ToUpper();

            return overlay;
        }


        private String getSymbolTableName(String folder, String languagefile)
        {
            return getEntryValue(languagefile, "symboltables_" + folder + "_title");
        }

        private String getLicenseLabel(String languagefile)
        {
            return getEntryValue(languagefile, "licenses_symboltablesources");
        }

        #endregion

        #region special sorts

        /// <summary>
        /// special sort
        /// </summary>
        public class NameSort : Comparer<Object>
        {
            List<String> translateables;

            public NameSort(List<String> translateables)
            {
                this.translateables = translateables;
            }

            override public int Compare(Object _a, Object _b)
            {
                int intA;
                int intB;
                String keyA = ((SymbolInfo)_a).Overlay.ToString();
                String keyB = ((SymbolInfo)_b).Overlay.ToString();


                if (!int.TryParse(keyA, out intA))
                {
                    if (!int.TryParse(keyB, out intB))
                    {
                        return lowerCase(keyA, keyB);
                    }
                    else
                        return 1;
                }
                else
                {
                    if (!int.TryParse(keyB, out intB))
                        return -1;
                    else
                        return intA.CompareTo(intB);
                }
            }

            static int lowerCase(string a, string b)
            {
                if ((a == String.Empty) | (b == String.Empty))
                    return a.CompareTo(b);

                var abytes = System.Text.Encoding.Default.GetBytes(a);
                var bbytes = System.Text.Encoding.Default.GetBytes(b);

                if (abytes[0] != bbytes[0])
                    return abytes[0].CompareTo(bbytes[0]);
                else
                    return a.CompareTo(b);


            }
        }

        /// <summary>
        /// special sort
        /// </summary>
        public class specialSortNoteNames : Comparer<Object>
        {
            List<String> translateables;

            public specialSortNoteNames(List<String> translateables)
            {
                this.translateables = translateables;
            }

            override public int Compare(Object _a, Object _b)
            {
                var keyA = Path.GetFileNameWithoutExtension(_a.ToString()); // get filename from path without suffix
                var keyB = Path.GetFileNameWithoutExtension(_b.ToString());

                var aSplit = keyA.Split('_');
                var aMain = 0;
                int.TryParse(aSplit[0], out aMain);
                var aSign = "";
                if (aSplit.Length > 1)
                    aSign = aSplit[1];

                var bSplit = keyB.Split('_');
                var bMain = 0;
                int.TryParse(bSplit[0], out bMain);
                var bSign = "";
                if (bSplit.Length > 1)
                    bSign = bSplit[1];

                var compareSign = aSign.CompareTo(bSign);
                if (compareSign != 0)
                    return compareSign;

                return aMain.CompareTo(bMain);
            }
        }

        /// <summary>
        /// special sort
        /// </summary>
        public class specialSortNoteValues : Comparer<Object>
        {
            List<String> translateables;

            public specialSortNoteValues(List<String> translateables)
            {
                this.translateables = translateables;
            }

            override public int Compare(Object _a, Object _b)
            {
                var keyA = Path.GetFileNameWithoutExtension(_a.ToString()); // get filename from path without suffix
                var keyB = Path.GetFileNameWithoutExtension(_b.ToString());


                var aSplit = keyA.Split('_');
                int aDotted = 0;
                int aValue = 0;
                int.TryParse(aSplit[0], out aDotted);
                if (aSplit.Length > 1)
                    int.TryParse(aSplit[1], out aValue);

                var bSplit = keyB.Split('_');
                int bDotted = 0;
                int bValue = 0;
                int.TryParse(bSplit[0], out bDotted);
                if (bSplit.Length > 1)
                    int.TryParse(bSplit[1], out bValue);

                var compareDotted = aDotted.CompareTo(bDotted);
                if (compareDotted != 0)
                    return compareDotted;

                return bValue.CompareTo(aValue);
            }
        }

        /// <summary>
        /// special sort
        /// </summary>
        public class specialSortTrafficSignsGermany : Comparer<Object>
        {
            List<String> translateables;

            public specialSortTrafficSignsGermany(List<String> translateables)
            {
                this.translateables = translateables;
            }

            override public int Compare(Object _a, Object _b)
            {
                var keyA = ((SymbolInfo)_a).Overlay.ToString();
                var keyB = ((SymbolInfo)_b).Overlay.ToString();

                var aSplitDash = keyA.Split('-');
                var bSplitDash = keyB.Split('-');
                var aSplitDot = aSplitDash[0].Split('.');
                var bSplitDot = bSplitDash[0].Split('.');

                int aMain = 0;
                int.TryParse(aSplitDot[0], out aMain);
                var aDot = 0;
                if (aSplitDot.Length > 1)
                    int.TryParse(aSplitDot[1], out aDot);
                var aDash = 0;
                if (aSplitDash.Length > 1)
                    int.TryParse(aSplitDash[1], out aDash);

                var bMain = 0;
                int.TryParse(bSplitDot[0], out bMain);
                var bDot = 0;
                if (bSplitDot.Length > 1)
                    int.TryParse(bSplitDot[1], out bDot);
                var bDash = 0;
                if (bSplitDash.Length > 1)
                    int.TryParse(bSplitDash[1], out bDash);

                var compareMain = aMain.CompareTo(bMain);
                if (compareMain != 0)
                    return compareMain;

                var compareDot = aDot.CompareTo(bDot);
                if (compareDot != 0)
                    return compareDot;

                var compareDash = aDash.CompareTo(bDash);
                if (compareDash != 0)
                    return compareDash;

                return 0;
            }
        }

        #endregion

        #region own translations 

        /// <summary>
        /// config content (label, font)
        /// </summary>
        /// <returns></returns>
        private Tuple<String, String> getContentTableName()
        {
            CONFIG_Font = CONFIG_DefaultFont;
            String contentTableName;

            switch (Language)
            {
                case "de":
                    contentTableName = "Inhaltsverzeichnis";
                    break;
                case "fr":
                    contentTableName = "Table des matières";
                    break;
                case "ko":
                    contentTableName = "목차";
                    CONFIG_Font = "Malgun Gothic";
                    FontEmbeded = true;
                    break;
                case "it":
                    contentTableName = "Sommario";
                    break;
                case "es":
                    contentTableName = "Tabla de contenido";
                    break;
                case "nl":
                    contentTableName = "Inhoudsopgave";
                    break;
                case "pl":
                    contentTableName = "Spis treści";
                    break;
                case "ru":
                    contentTableName = "Оглавление";
                    break;
                case "sk":
                    contentTableName = "Obsah";
                    break;
                case "sv":
                    contentTableName = "Innehållsförteckning";
                    break;
                case "tr":
                    contentTableName = "İçindekiler";
                    break;
                default:
                    contentTableName = "Table of Contents";
                    break;
            }

            return new Tuple<String, String>(contentTableName, CONFIG_Font);

        }

        private String getSourceLabel()
        {
            switch (Language)
            {
                case "de":
                    return "Quelle";
                case "fr":
                    return "La source";
                case "ko":
                    return "원천";
                case "it":
                    return "Fonte";
                case "es":
                    return "origen";
                case "nl":
                    return "Bron";
                case "pl":
                    return "Źródło";
                case "ru":
                    return "Источник";
                case "sk":
                    return "Zdroj";
                case "sv":
                    return "Lälla";
                case "tr":
                    return "Kaynak";
                default:
                    return "Source";
            }
        }

        #endregion


    }
}
