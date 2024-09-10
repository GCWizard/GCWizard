using PdfSharp.Drawing;
using PdfSharp.Pdf;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

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
		//const bool testPage = false;

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


		private double _Progress;
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

		private int _SymbolTablesCount;
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

		private int _SymbolImagesCount;
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

		public PdfDocument CreatePdfDocument(String path)
		{
			try
			{
				// Create a new PDF document
				PdfDocument document = new PdfDocument();
				document.Info.Title = "GC Wizard Symbol Tables";

				DrawSymbolTables(path, document);

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
		public static bool SavePdfDocument(String path, PdfDocument document)
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
		private void DrawSymbolTables(String path, PdfDocument document)
		{
			PointF offset;
			var languagefile = File.ReadAllText(LanguageFileName(path));
			var languagefileEn = File.ReadAllText(LanguageFileNameEn(path));
			var licenseEntries = GetLicenseEntries(File.ReadAllText(LicenseTypesFileName(path)),
				File.ReadAllText(LicenseTypesSpecificFileName(path)),
				File.ReadAllText(RegistryFileName(path)),
				languagefile, languagefileEn);

			ProjectPath = path;
			PdfPage page = null;
			// Get an XGraphics object for drawing
			XGraphics gfx = null;
			Progress = 0;

			// Create the root bookmark. You can set the style and the color.
			var config = GetContentTableName();
			var contentTableName = config.Item1;
			CONFIG_Font = config.Item2;
			offset = CreatePage(document, ref page, ref gfx);

			Outline = document.Outlines.Add(contentTableName, page, true, PdfOutlineStyle.Bold, XColors.Black);

			var directorys = CreateDirectoryList(path, languagefile, languagefileEn);
			var progress_offset = directorys.Any() ? (100.0 / directorys.Count()) : 100;
			foreach (var entry in directorys)
			{
				//Debug.Print(licenseEntry.Value);
				offset = DrawSymbolTable(path, entry.Value, entry.Key, document, ref page, ref gfx, offset, languagefile, languagefileEn, licenseEntries);

				offset.X = BorderWidthLeft;
				offset.Y += ImageSize + 20;

				Progress += progress_offset;
			}

			//offset = DrawLicenses(document, ref page, ref gfx, offset, languagefile, languagefileEn, licenseEntries);

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
		private PointF DrawSymbolTable(String path, String name, String folder, PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset, String languagefile, String languagefileEn, Dictionary<string, string> licenseEntries)
		{
			var description = GetEntryValue(languagefile, "symboltables_" + folder + "_description");
			var license = "";
			if (licenseEntries.ContainsKey(folder))
			{
				var label = GetSourceLabel();
				var licenseEntry = licenseEntries[folder];

                // only license available ?
                if (licenseEntry.StartsWith("(") & licenseEntry.EndsWith(")"))
                {
					licenseEntry = licenseEntry.Substring(1, licenseEntry.Count() -2);
                    label = GetLicenseLabel();
                }

                license =  label + ": " + licenseEntry;
			}

			if (name == null)
				name = folder;

			var symbolList = CreateSymbolList(path, folder, languagefile, languagefileEn);
			offset = DrawName(name, description, license, symbolList.Count(), document, ref page, ref gfx, offset);
			SymbolTablesCount += 1;

			foreach (var symbol in symbolList)
			{
				offset = DrawImage(symbol.Value.Stream, document, ref page, ref gfx, offset, symbol.Value.Overlay);
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
		private IEnumerable<KeyValuePair<String, SymbolInfo>> CreateSymbolList(String path, String _symbolKey, String languagefile, String languagefileEn)
		{
			var list = new Dictionary<String, SymbolInfo>();
			var overlay = String.Empty;
			var _path = SymbolTablesDirectory(path);
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
				translateList = ParseTranslateConfig(fileContent);
				translateables = new List<String>();
				ignoreList = ParseIgnoreConfig(fileContent);
				mappingList = ParseMappingConfig(fileContent);
				caseSensitive = ParseCaseSensitiveConfig(fileContent);
				specialSort = ParseSpecialSortConfig(fileContent);
				translationPrefixConfig = ParseTranslationPrefixConfig(fileContent);
			}
			else
				mappingList = ParseMappingConfig(null);

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
							overlay = SymbolOverlay(symbol, _symbolKey, languagefile, languagefileEn, translateList, mappingList, caseSensitive, ref translateables, translationPrefixConfig);
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
					case "notes_names_altoclef": _sort = new SpecialSortNoteNames(translateables); break;
					case "notes_names_bassclef": _sort = new SpecialSortNoteNames(translateables); break;
					case "notes_names_trebleclef": _sort = new SpecialSortNoteNames(translateables); break;
					case "notes_notevalues": _sort = new SpecialSortNoteValues(translateables); break;
					case "notes_restvalues": _sort = new SpecialSortNoteValues(translateables); break;
					case "trafficsigns_germany": _sort = new SpecialSortTrafficSignsGermany(translateables); break;
					default: _sort = new NameSort(translateables); break;
				}
			}

			var listSorted = list.ToList();
			if (_sort is SpecialSortNoteNames || _sort is SpecialSortNoteValues)
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
		private PointF DrawName(String name, string description, string license, int count, PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset)
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
				offset = CreatePage(document, ref page, ref gfx);
			else if (offset.Y + name_offset + (ImageSize + RowDistance) > page.Height - BorderWidthBottom)
			{
				if (count > RowImageCount(ref page))
					offset = CreatePage(document, ref page, ref gfx);
			}
			else if (offset.Y + name_offset + 2 * (ImageSize + RowDistance) > page.Height - BorderWidthBottom)
			{
				if (count > 2 * RowImageCount(ref page))
					offset = CreatePage(document, ref page, ref gfx);
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
		/// draw symbol overlay textLines
		/// </summary>
		/// <param name="name"></param>
		/// <param name="maxLength"></param>
		/// <param name="document"></param>
		/// <param name="page"></param>
		/// <param name="gfx"></param>
		/// <param name="offset"></param>
		/// <returns>new bottom position</returns>
		private PointF DrawOverlay(String name, int maxLength, ref XGraphics gfx, PointF offset)
		{
			// Create a font
			XFont font = CreateXFont(CONFIG_Font, FontSizeOverlay, XFontStyle.Regular);
			if (name == " ")
			{
				offset.Y = (float)DrawSpaceSymbol(offset, XColors.Blue, font, gfx);
				return offset;
			}

			// Draw the name
			var textLines = SplitText(gfx, font, maxLength, name);
			offset.Y = (float)DrawTextBlock(gfx, new XRect(offset.X, offset.Y, ImageSize, 2 * FontSizeOverlay), font, XBrushes.Blue, textLines);
			return offset;
		}

		/// <summary>
		/// draw space symbol
		/// </summary>
		/// <param name="position"></param>
		/// <param name="color"></param>
		/// <param name="font"></param>
		/// <param name="gfx"></param>
		private static double DrawSpaceSymbol(PointF position, XColor color, XFont font, XGraphics gfx)
		{
			var size = gfx.MeasureString("M", font);
			var pen = new XPen(color, 1);
			var yPosition = position.Y + size.Height;

			gfx.DrawLine(pen, new XPoint(position.X, yPosition), new XPoint(position.X + size.Width, yPosition));
			gfx.DrawLine(pen, new XPoint(position.X, yPosition), new XPoint(position.X, yPosition * 0.8));
			gfx.DrawLine(pen, new XPoint(position.X + size.Width, yPosition), new XPoint(position.X + size.Width, yPosition * 0.8));

			return yPosition;
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
		private PointF DrawImage(Stream symbolStream, PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset, String overlay)
		{
			XImage image = XImage.FromGdiPlusImage(Image.FromStream(symbolStream));
			XSize size = image.Size;
			var ImageScale = ImageSize / size.Height;
			size.Width *= ImageScale;
			size.Height *= ImageScale;

			if (page == null)
				offset = CreatePage(document, ref page, ref gfx);
			else if (offset.X + size.Width > page.Width - BorderWidthRight)
			{
				// new Row
				offset.X = BorderWidthLeft;
				offset.Y += (Single)size.Height + RowDistance;
			}

			if (offset.Y + size.Height > page.Height - BorderWidthBottom)
				offset = CreatePage(document, ref page, ref gfx);

			gfx.DrawImage(image, offset.X, offset.Y, size.Width, size.Height);
			image.Dispose();

			// Border
			gfx.DrawRectangle(new XPen(XColor.FromArgb(Color.Gray.ToArgb()), 0.2), offset.X, offset.Y, size.Width, size.Height);

			// Draw the overlay
			DrawOverlay(overlay, (int)(size.Width + ColumnDistance - 2), ref gfx, new PointF(offset.X, (Single)(offset.Y + size.Height)));

			offset.X += (Single)size.Width + ColumnDistance;

			return offset;
		}

		/// <summary>
		/// draw licenses textLines
		/// </summary>
		/// <param name="document"></param>
		/// <param name="page"></param>
		/// <param name="gfx"></param>
		/// <param name="offset"></param>
		/// <param name="languagefile"></param>
		/// <param name="languagefileEn"></param>
		/// <param name="licenseEntries"></param>
		private PointF DrawLicenses(PdfDocument document, ref PdfPage page, ref XGraphics gfx, PointF offset, String languagefile, String languagefileEn, Dictionary<string, string> licenseEntries)
		{
			var licenseLabel = (GetLicenseLabel(languagefile) ?? GetLicenseLabel(languagefileEn)) + "/ " + (GetLicenseLabel1(languagefile) ?? GetLicenseLabel1(languagefileEn));

			// Create a font
			XFont font = CreateXFont(CONFIG_Font, FontSizeName, XFontStyle.BoldItalic);
			offset = CreatePage(document, ref page, ref gfx);


			gfx.DrawString(licenseLabel, font, XBrushes.Black,
				new XRect(offset.X, offset.Y, page.Width, page.Height),
				XStringFormats.TopLeft);
			Outline = document.Outlines.Add(licenseLabel, page, true, PdfOutlineStyle.Bold, XColors.Black);

			var name_offset = font.Height;
			name_offset += 20;

			offset.Y += name_offset;

			// Create a font
			font = CreateXFont(CONFIG_Font, FontSizeName / 2, XFontStyle.Regular);

			double maxNameSize = 0;

			foreach (var entry in licenseEntries)
			{
				var name = GetSymbolTableName(entry.Key, languagefile, languagefileEn) + ":";
				var size = gfx.MeasureString(name, font);
				if (maxNameSize < size.Width)
					maxNameSize = size.Width;
			}
			var nameLength = (int)(offset.X + maxNameSize + 10);
			nameLength = Math.Min((int)((page.Width - BorderWidthRight - BorderWidthLeft)/3), nameLength);


			foreach (var entry in licenseEntries)
			{
				if (NewPageNeeded(page, offset, font.Height + 1))
				{
					offset = CreatePage(document, ref page, ref gfx);
				}

				var name = GetSymbolTableName(entry.Key, languagefile, languagefileEn);
				if (name != null)
				{
					var textLines = SplitText(gfx, font, nameLength, name);
					var offsetY1 = DrawTextBlock(gfx, new XRect(offset.X, offset.Y, page.Width, page.Height), font, XBrushes.Black, textLines);

					// split textLines
					var maxSourceLength = (int)(page.Width - offset.X - BorderWidthRight - nameLength);
					textLines = SplitText(gfx, font, maxSourceLength, entry.Value);
					var offsetY2 = DrawTextBlock(gfx, new XRect(BorderWidthLeft + nameLength, offset.Y, page.Width, page.Height), font, XBrushes.Black, textLines);

					offset.Y = (float)Math.Max(offsetY1, offsetY2);
				}
			}

			return offset;
		}

		/// <summary>
		/// draw text lines
		/// </summary>
		/// <param name="page"></param>
		/// <param name="gfx"></param>
		/// <param name="offset"></param>
		/// <param name="font"></param>
		/// <param name="valueOffsetX"></param>
		/// <param name="textLines"></param>
		/// <returns></returns>
		private static double DrawTextBlock(XGraphics gfx, XRect offset, XFont font, XBrush brush, List<string> textLines)
		{
			for (int i = 0; i < textLines.Count; i++)
			{
				gfx.DrawString(textLines[i], font, brush, offset, XStringFormats.TopLeft);

				offset.Y += font.Height + ((i == textLines.Count - 1) ? 1 : 0);
			}

			return offset.Y;
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
		private bool NewPageNeeded(PdfPage page, PointF offset, int name_offset)
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
		private PointF CreatePage(PdfDocument document, ref PdfPage page, ref XGraphics gfx)
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
				text = File.ReadAllText(VersionFileName(ProjectPath));
				versionText = GetVersionEntryValue(text, "version");
			}

			textSize = gfx.MeasureString(versionText, font);
			// draw the version textLines
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
		/// split textLines in lines
		/// </summary>
		/// <param name="gfx"></param>
		/// <param name="font"></param>
		/// <param name="maxLength"></param>
		/// <param name="text"></param>
		/// <returns>splittedText</returns>
		private static List<string> SplitText(XGraphics gfx, XFont font, int maxLength, string text)
		{
			var textValues = text.Replace("\\n", "\n").Split('\n');
			var textList = new List<String>();
			foreach (var item in textValues)
			{
				var values = CheckTextLength(item.Replace("\r", ""), maxLength, font, gfx);
				textList.AddRange(values.Split('\n'));
			}

			return textList;
		}

		/// <summary>
		/// wrap textLines if too long 
		/// </summary>
		/// <param name="text"></param>
		/// <param name="maxLength"></param>
		/// <param name="font"></param>
		/// <param name="gfx"></param>
		/// <returns></returns>
		private static string CheckTextLength(string text, int maxLength, XFont font, XGraphics gfx)
		{
			text = WrapPartTextLength(text, maxLength, font, gfx);
			var index = text.LastIndexOf("\n");

			if (index >= 0)
			{
				var subString = text.Substring(index);
				var size = gfx.MeasureString(subString, font);
				while (size.Width > maxLength)
				{
					subString = WrapPartTextLength(subString, maxLength, font, gfx);

					text = text.Substring(0, index) + subString;

					index = text.LastIndexOf("\n") + 1;
					subString = text.Substring(index);
					size = gfx.MeasureString(subString, font);
				}
			}
			return text;
		}

		/// <summary>
		/// wrap textLines if too long
		/// </summary>
		/// <param name="text"></param>
		/// <param name="maxLength"></param>
		/// <param name="font"></param>
		/// <param name="gfx"></param>
		/// <returns></returns>
		private static string WrapPartTextLength(string text, int maxLength, XFont font, XGraphics gfx)
		{
			var size = gfx.MeasureString(text, font);

			if (size.Width <= maxLength)
				return text;

			int textSplit(string _text, char _char)
			{
				var _index = text.LastIndexOf(_char);
				while (_index > 0)
				{
					size = gfx.MeasureString(_text.Substring(0, _index), font);
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
			}
			string buildResult(string _text, int _index)
			{
				return _text.Substring(0, _index) + Environment.NewLine + _text.Substring(_index).Trim();
			}

			var index = textSplit(text, ' ');
			if (index > 1)
				return buildResult(text, index);

			index = textSplit(text, '/');
			if (index > 0)
				return buildResult(text, index + 1);

			index = textSplit(text, ',');
			if (index > 0)
				return buildResult(text, index + 1);

			index = textSplit(text, ')');
			if (index > 0)
				return buildResult(text, index + 1);

			for (index = text.Length - 1; index >= 0; index--)
			{
				size = gfx.MeasureString(text.Substring(0, index), font);
				if (size.Width <= maxLength)
					return buildResult(text, index);
			}

			return text;


		}

		/// <summary>
		/// calc images per row 
		/// </summary>
		/// <param name="page"></param>
		/// <returns></returns>
		private int RowImageCount(ref PdfPage page)
		{
			return (int)Math.Floor((page.Width - BorderWidthLeft - BorderWidthRight) / (ImageSize + ColumnDistance));
		}

		private XFont CreateXFont(String familyName, double emSize, XFontStyle style)
		{
			var xFont = FontList.Where(font => (font.Name == familyName) & (font.Size == emSize) & (font.Style == style)).FirstOrDefault();

			if (xFont != null) return xFont;

			// Set font encoding to unicode always
			XPdfFontOptions options = new XPdfFontOptions(PdfFontEncoding.Unicode, PdfFontEmbedding.Always);

			xFont = new XFont(familyName, emSize, style, FontEmbeded ? options : null);

			FontList.Add(xFont);
			return xFont;
		}

		#endregion

		#region parse config file

		private List<String> ParseTranslateConfig(String fileContent)
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

		private Dictionary<String, String> ParseMappingConfig(String fileContent)
		{
			var regex = new Regex(@"(" + CONFIG_SPECIALMAPPINGS + @")(.*?)(\{)(.*?)(\})", RegexOptions.Singleline | RegexOptions.IgnoreCase);
			var regex2 = new Regex(@"\""(.*?)\""(\s*:\s*)\""(.*?)\""");
			var list = DefaultMappingList();

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

		private List<String> ParseIgnoreConfig(String fileContent)
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

		private Dictionary<String, String> DefaultMappingList()
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

		private bool ParseCaseSensitiveConfig(String fileContent)
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

		private bool ParseSpecialSortConfig(String fileContent)
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

		private String ParseTranslationPrefixConfig(String fileContent)
		{
			return GetEntryValue(fileContent, CONFIG_TRANSLATIONPREFIX);
		}

		#endregion

		#region parse source files

		/// <summary>
		/// get textLines from language-file
		/// </summary>
		/// <param name="fileContent"></param>
		/// <param name="entry"></param>
		/// <returns></returns>
		private static String GetEntryValue(String fileContent, String entry)
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
		/// get textLines from version-file
		/// </summary>
		/// <param name="fileContent"></param>
		/// <param name="entry"></param>
		/// <returns></returns>
		private static String GetVersionEntryValue(String fileContent, String entry)
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
		/// get textLines from license-file
		/// </summary>
		/// <param name="licenseTypesContent"></param>
		/// <returns></returns>
		private Dictionary<String, String> GetLicenseEntries(String licenseTypesContent, String licenseTypesSpecificContent, String registryContent, String languagefile, String languagefileEn)
		{
			var list = new Dictionary<String, String>();
			var licensesList = AllLicensesTypes(licenseTypesContent, licenseTypesSpecificContent, languagefile, languagefileEn);

			// parse registry
			var symboltablesRegEx = new Regex(@"GCWSymbolTableTool.*?symbolKey\s*:(.*?),.*?licenses\s*\:\s*\[(.*?)]", RegexOptions.Singleline);
			var licensesTypeRegEx = new Regex(@"ToolLicense.*?licenseType\s*:(.*?)[,|\)]", RegexOptions.Singleline);
			var licensesSourceUrlRegEx = new Regex(@"ToolLicense.*?sourceUrl\s*:(.*?)[,|\)]", RegexOptions.Singleline);
			var licensesPrivatePermissionRegEx = new Regex(@"ToolLicensePrivatePermission.*?medium\s*:(.*?)[,|\)]", RegexOptions.Singleline);
			var registryEntries = symboltablesRegEx.Matches(registryContent);

			foreach (Match match in registryEntries)
			{
				if (!String.IsNullOrEmpty(match.Groups[2].Value.Trim())) //licenses block
				{
					var licensesEntries = licensesTypeRegEx.Matches(match.Groups[2].Value);
					if (licensesEntries.Count > 0) //licenseEntry with licenseType ?
					{
						var title = RemoveQuotationMark(match.Groups[1].Value).Trim();
						var usedEntry = licensesEntries[0]; // first license with licenseType

						var licenseEntry = usedEntry.Groups[1].Value.Trim();
						if (licensesList.ContainsKey(licenseEntry))
							licenseEntry = licensesList[licenseEntry];

						if (String.IsNullOrEmpty (licenseEntry)) 
						{
							var privatePermission = licensesPrivatePermissionRegEx.Match(match.Groups[0].Value);
							if (privatePermission.Success)
								licenseEntry = RemoveQuotationMark(privatePermission.Groups[1].Value).Trim();
						}

						var entry = String.IsNullOrEmpty(licenseEntry) ? "" :  "(" + licenseEntry + ")";

						var sourceUrlEntry = licensesSourceUrlRegEx.Match(usedEntry.Groups[0].Value);
						if (sourceUrlEntry.Success)
						{
							var sourceEntry = FormatSourceUrl(sourceUrlEntry.Groups[1].Value);
							if (!String.IsNullOrEmpty(sourceEntry))
								entry = sourceEntry + " " + entry;
						}

						list.Add(title, entry);
					}
				}
			}
			return list;
		}

		private static Dictionary<String, String> AllLicensesTypes(String licenseTypesContent, String licenseTypesSpecificContent, string languagefile, string languagefileEn)
		{
			var licensesList = new Dictionary<String, String>();
			var licensesTypesRegEx = new Regex(@"switch.*?licenseType.*?{(.*?)}", RegexOptions.Singleline);
			var licensesTypeRegEx = new Regex(@"case(.*?):.*?return(.*?);", RegexOptions.Singleline);
			var licensesTypesEntry = licensesTypesRegEx.Match(licenseTypesContent);
			var i18nRegEx = new Regex(@"i18n.*'(.*?)'", RegexOptions.Singleline);

			if (licensesTypesEntry != null)
			{
				// all possible licenses enums
				var licensesTypeEntries = licensesTypeRegEx.Matches(licensesTypesEntry.Value);

				// all possible licenses texts
				foreach (Match match in licensesTypeEntries)
				{
					var text = match.Groups[2].Value.Trim();
					var i18nMatch = i18nRegEx.Match(text);
					if (i18nMatch.Success) //translated Text ?
						text = TranslatedText(languagefile, languagefileEn, i18nMatch.Groups[1].Value, text);
					else
						text = RemoveQuotationMark(text);
					licensesList.Add(match.Groups[1].Value.Trim(), text);
				}
			}

			return licensesList;
		}

		private static String FormatSourceUrl(String url)
		{
			var result = url;
			var webArchiveRegEx = new Regex(@"https://web.archive.org/web/[\d]+/(.*)'", RegexOptions.Singleline);
            var webArchiveRegEx1 = new Regex(@"http://web.archive.org/web/[\d]+/(.*)'", RegexOptions.Singleline);

            if (url.Contains("wikipedia") && url.Contains("&oldid"))
				result = url.Substring(0, url.IndexOf("&oldid"));
			else if (webArchiveRegEx.Match(url).Success)
				result = webArchiveRegEx.Match(url).Groups[1].Value;
            else if (webArchiveRegEx1.Match(url).Success)
                result = webArchiveRegEx1.Match(url).Groups[1].Value;

            return RemoveQuotationMark(result.Trim());
		}

		private static String RemoveQuotationMark(String text)
		{
			return text.Replace("'", "");
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
		private IEnumerable<KeyValuePair<String, String>> CreateDirectoryList(String path, String languagefile, String languagefileEn)
		{
			var list = new Dictionary<String, String>();
			foreach (var directory in Directory.GetDirectories(SymbolTablesDirectory(path)))
			{
				var folder = @directory.Substring(directory.LastIndexOf(Path.DirectorySeparatorChar) + 1);
				var name = GetSymbolTableName(folder, languagefile, languagefileEn);

				if (name != null && directory != "backlog")
					list.Add(folder, name);
			}

			var query = list.OrderBy(entry => entry.Value);
			//if (testPage) return query.Take(1);

			return query;
		}


		/// <summary>
		/// language file exists ?
		/// </summary>
		/// <param name="path"></param>
		/// <returns></returns>
		public bool ValidFolder(String path)
		{
			if (!Directory.Exists(LanguageFileDirectory(path)))
				return false;
			if (!File.Exists(LanguageFileName(path)))
				return false;

			if (!Directory.Exists(SymbolTablesDirectory(path)))
				return false;

			return true;
		}

		public static String LanguageFileDirectory(String path)
		{
			return Path.Combine(path, @"lib\application\i18n\assets");
		}

		private String LanguageFileName(String path)
		{
			return Path.Combine(LanguageFileDirectory(path), Language + @".json");
		}

		private String LanguageFileNameEn(String path)
		{
			return Path.Combine(LanguageFileDirectory(path), "en" + @".json");
		}

		private static String VersionFileName(String path)
		{
			return Path.Combine(path, "pubspec.yaml");
		}


		private static String LicenseTypesFileName(String path)
		{
			return Path.Combine(path, @"lib/application/tools/tool_licenses/widget/tool_license_types.dart");
		}

		private static String LicenseTypesSpecificFileName(String path)
		{
			return Path.Combine(path, @"lib/application/tools/tool_licenses/widget/specific_tool_licenses.dart");
		}

		private static String RegistryFileName(String path)
		{
			return Path.Combine(path, @"lib\application\registry.dart");
		}

		private static String SymbolTablesDirectory(String path)
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
		private static String SymbolOverlay(String symbolPath, String folder, String languagefile, String languagefileEn, List<String> translateList, Dictionary<String, String> mappingList, bool caseSensitive, ref List<String> translateables, String translationPrefix)
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
				overlay = TranslatedText(languagefile, languagefileEn, entry, overlay);
				translateables.Add(overlay);
			}

			if (!caseSensitive)
				overlay = overlay.ToUpper();

			return overlay;
		}

		private static String GetSymbolTableName(String folder, String languagefile, String languagefileEn)
		{
			return GetSymbolTableName(folder, languagefile) ?? GetSymbolTableName(folder, languagefileEn); ;
		}

		private static String GetSymbolTableName(String folder, String languagefile)
		{
			return GetEntryValue(languagefile, "symboltables_" + folder + "_title");
		}

		private static String GetLicenseLabel(String languagefile)
		{
			return GetEntryValue(languagefile, "licenses_symboltablesources");
		}

		private static String GetLicenseLabel1(String languagefile)
		{
			return GetEntryValue(languagefile, "licenses_title");
		}

		private static string TranslatedText(string languagefile, string languagefileEn, string entry, string notTranslatedText)
		{
			return GetEntryValue(languagefile, entry) ?? GetEntryValue(languagefileEn, entry) ?? notTranslatedText;
		}

		#endregion

		#region special sorts

		/// <summary>
		/// special sort
		/// </summary>
		public class NameSort : Comparer<Object>
		{
			private readonly List<String> translateables;

			public NameSort(List<String> translateables)
			{
				this.translateables = translateables;
			}

			override public int Compare(Object _a, Object _b)
			{
				String keyA = ((SymbolInfo)_a).Overlay.ToString();
				String keyB = ((SymbolInfo)_b).Overlay.ToString();


				if (!int.TryParse(keyA, out int intA))
				{
					return int.TryParse(keyB, out _) ? 1 : LowerCase(keyA, keyB);
				}
				else
				{
					if (!int.TryParse(keyB, out int intB))
						return -1;
					else
						return intA.CompareTo(intB);
				}
			}

			static int LowerCase(string a, string b)
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
		public class SpecialSortNoteNames : Comparer<Object>
		{
			private readonly List<String> translateables;

			public SpecialSortNoteNames(List<String> translateables)
			{
				this.translateables = translateables;
			}

			override public int Compare(Object _a, Object _b)
			{
				var keyA = Path.GetFileNameWithoutExtension(_a.ToString()); // get filename from path without suffix
				var keyB = Path.GetFileNameWithoutExtension(_b.ToString());

				var aSplit = keyA.Split('_');
				int.TryParse(aSplit[0], out int aMain);
				var aSign = "";
				if (aSplit.Length > 1)
					aSign = aSplit[1];

				var bSplit = keyB.Split('_');
				int.TryParse(bSplit[0], out int bMain);
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
		public class SpecialSortNoteValues : Comparer<Object>
		{
			private readonly List<String> translateables;

			public SpecialSortNoteValues(List<String> translateables)
			{
				this.translateables = translateables;
			}

			override public int Compare(Object _a, Object _b)
			{
				var keyA = Path.GetFileNameWithoutExtension(_a.ToString()); // get filename from path without suffix
				var keyB = Path.GetFileNameWithoutExtension(_b.ToString());


				var aSplit = keyA.Split('_');
				int.TryParse(aSplit[0], out int aDotted);
				if (aSplit.Length > 1)
					int.TryParse(aSplit[1], out _);

				var bSplit = keyB.Split('_');
				int bValue = 0;
				int.TryParse(bSplit[0], out int bDotted);
				if (bSplit.Length > 1)
					int.TryParse(bSplit[1], out bValue);

				var compareDotted = aDotted.CompareTo(bDotted);
				if (compareDotted != 0)
					return compareDotted;

				return bValue.CompareTo(0);
			}
		}

		/// <summary>
		/// special sort
		/// </summary>
		public class SpecialSortTrafficSignsGermany : Comparer<Object>
		{
			private readonly List<String> translateables;

			public SpecialSortTrafficSignsGermany(List<String> translateables)
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

				int.TryParse(aSplitDot[0], out int aMain);
				var aDot = 0;
				if (aSplitDot.Length > 1)
					int.TryParse(aSplitDot[1], out aDot);
				var aDash = 0;
				if (aSplitDash.Length > 1)
					int.TryParse(aSplitDash[1], out aDash);

				int.TryParse(bSplitDot[0], out int bMain);
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
		private Tuple<String, String> GetContentTableName()
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

		private String GetSourceLabel()
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

		private String GetLicenseLabel()
		{
			switch (Language)
			{
				case "de":
					return "Lizenz";
				case "fr":
					return "Licence";
				case "ko":
					return "특허";
				case "it":
					return "Licenza";
				case "es":
					return "Licencia";
				case "nl":
					return "Licentie";
				case "pl":
					return "Licencja";
				case "ru":
					return "Лицензия";
				case "sk":
					return "Licencia";
				case "sv":
					return "Licenca";
				case "tr":
					return "Lisans";
				default:
					return "License";
			}
		}

		#endregion

	}
}
