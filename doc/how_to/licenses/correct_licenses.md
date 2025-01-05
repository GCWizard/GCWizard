# HowTo: Correct Licenses
## Write License
### Where to add
* All license types inherit from ``ToolLicenceEntry``
* Each ``GCWTool`` knows its licenses (field ``List<ToolLicenseEntry> licenses``)
* Therefore the licenses are added in the (much too long!!!!) ``registry.dart``
* **EVERY** tool which was written with the help of any source should get the related license/source
* This means: Not the top groups or something, it should all go into the final tools
* This can result in huge license text duplications: For this there is a file ``specific_tool_licenses.dart`` where you can put the license object once and reference it as often as you like in the registry
* If something is not used for a specific tool but in a more global way, like most of the Flutter libraries, they can be added in the ``licenses.dart`` file instead directly.
### License types
* Every license type described below has field for private permission, which means: This can be used to describe if something was explicitly use permitted to us (via email, forum, whatever...):
  * class type ``ToolLicensePrivatePermission``
  * required fields:
    * ``medium``: How was the permission granted (possible values are ``e-mail``, ``PN in geoclub.de forum``)
    * ``permissionYear`` (at least the year should be clear)
  * optional fields:
    * ``permissionMonth``, ``permissionDay`` (if available)
    * ``permissionAuthor`` (if someone else but the original artifact author permitted the usage, e.g. a museum allowed us the use of an older document)
  * some license types require ``licenseType`` mandatorily. In that case use ``ToolLicenseType.PRIVATE_PERMISSION``

There is support for several license types:
* Included Code Libraries
  * class type ``ToolLibraryCodeLibrary``
  * This includes everything which is embedded via ``pubspec.yaml``
  * These are mainly Flutter/Dart libraries
  * required fields:
    * ``author``
    * ``title``
    * ``sourceUrl``
    * ``licenseType``
  * optional fields:
    * ``version`` (if available)
    * ``licenseUrl`` (if available)
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
* Ported Code
  * class type ``ToolLicensePortedCode``
  * This is for code which was copied into the codebase, maybe because it was ported from an external C++ library (e.g. the GeographicLib)
  * required fields:
    * ``author``
    * ``title``
    * ``sourceUrl``
    * ``licenseType``
  * optional fields:
    * ``version`` (if available)
    * ``licenseUrl`` (if available)
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
* External Images
  * class type ``ToolLicenseImage``
  * This is explicitely **NOT** images which we generated from fonts
  * This includes symbol tables which were not generated from any font
  * required fields:
    * ``author``
    * ``title`` (ok, I confess, this might be hard; maybe write the source article title or whatever)
    * ``sourceUrl``
    * ``licenseType``
  * optional fields:
    * ``version`` (if available)
    * ``licenseUrl`` (if available)
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
* External Fonts
  * class type ``ToolLicenseFont``
  * This includes real fonts we use (like __Roboto__ which is currently the default font of the app)
  * This includes everything we generated from a font (i.e. symbol tables)
  * This is explicitely **NOT** images which we generated from fonts
  * required fields:
    * ``author``
    * ``title`` (name of the font)
    * ``sourceUrl``
    * ``licenseType``
  * optional fields:
    * ``version`` (if available)
    * ``licenseUrl`` (if available)
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
* External API
  * class type ``ToolLicenseAPI``
  * This is for any external API we use (i.e. the Dow Jones API)
  * required fields:
    * ``author``
    * ``title``
    * ``sourceUrl`` (maybe the entry point of the API, even if it is invalid without any parameters)
    * ``licenseType``
  * optional fields:
    * ``version`` (if available)
    * ``licenseUrl`` (if available)
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
* Books which are online available
  * class type ``ToolLicenseOnlineBook``
  * required fields:
    * ``author``
    * ``title``
    * ``sourceUrl``
  * optional fields:
    * ``licenseType`` (if available, e.g. the Wikipedia license is CC BY-SA 4.0)
    * ``licenseUrl`` (if available)
    * ``year``, ``month``, ``day`` (publishing date; you can give ``year`` without ``month`` and ``day`` as well as ``year`` and ``month`` without ``day``)
    * ``isbn`` (if available)
    * ``publisher`` ("Verlag")
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
* Books which we used/read offline
  * class type ``ToolLicenseOfflineBook``
  * required fields:
    * ``author``
    * ``title``
  * optional fields:
    * ``year``, ``month``, ``day`` (publishing date; you can give ``year`` without ``month`` and ``day`` as well as ``year`` and ``month`` without ``day``)
    * ``isbn`` (if available)
    * ``publisher`` ("Verlag")
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
* Web Articles
  * class type ``ToolLicenseOnlineArticle``
  * Every online page, article, blog post, etc. which was used for research
  * This includes Wikipedia Articles
  * required fields:
    * ``author``
    * ``title``
    * ``sourceUrl``
  * optional fields:
    * ``licenseType`` (if available, e.g. the Wikipedia license is CC BY-SA 4.0)
    * ``licenseUrl`` (if available)
    * ``year``, ``month``, ``day`` (publishing date; you can give ``year`` without ``month`` and ``day`` as well as ``year`` and ``month`` without ``day``)
    * ``publisher`` ("Verlag")
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
* Offline Articles
  * class type ``ToolLicenseOfflineArticle``
  * Magazines, newspaper, ...
  * required fields:
    * ``author``
    * ``title``
  * optional fields:
    * ``year``, ``month``, ``day`` (publishing date; you can give ``year`` without ``month`` and ``day`` as well as ``year`` and ``month`` without ``day``)
    * ``publisher`` ("Verlag")
    * ``privatePermission`` (if exists)
    * ``customComment`` (for anything important, like license clarifications)
### Field Descriptions
* ``author``: Can be a list of authors or an organization
* ``sourceUrl``: This is the URL for the source
* ``licenseURL``: This is the URL of the source's license (e.g. in a code repository the ``sourceUrl`` could be the repo's main url whereas the ``licenseUrl`` is the link directly to the license file)
* ``licenseType``: enum of type ``ToolLicenseType``. Examples of available types:
  * ``FREE_TO_USE``,
  * ``APACHE2, // Apache 2.0``
  * ``CCBYSA4, // Creative Commons CC BY-SA 4.0``
  * ``CCBYSA2, // Creative Commons CC BY-SA 2.0``
  * ``CCNC25, // Creative Commons CC NC 2.5``
  * ``CC0_1, // Creative Commons CC0 1.0``
  * ``MIT, // MIT``
  * ``GPL3, //GNU GPL v3.0``
  * ``GITHUB_DEFAULT, //Github Default``
  * more can be added, of course; don't forget to add a ``String`` wrapper in the method ``_licenseType()`` right below the enum
### A word to the URLs
* URLs might be offline in the future. To ensure not getting any dead links, it is recommended to save the links, articles, whatever to the Wayback Machine/Internet Archive (https://web.archive.org/):
  * Copy the URL into the Internet Archive's search field:
    * if the website was already stored, choose the most recent snapshot, and copy the link for the related url
    * if the website was not already stored, there should be a button with something like "Store snapshot"; do this and copy the generated link
* Using Wikipedia or any other big source with an own version history:
  * (I believe the Internet Archive thing is not necessary here, but of course you could do that as well)
  * Ensure that you are not linking the article's main url, but to a fixed version:
    * The header of each article contains a "History"
    * Choose the most recent date and copy the link
* Using Github and other code repositories:
  * To ensure that the licenses of a certain used project will not be changen it could be a good idea to fork the repo to the own space. In Github you have a "fork" button on every main page of a project. This stores the current status of the project into your own space and ensures that you can reference to this actual license instead of something changed/removed/whatever
  * It could make sense to point to a certain commit in the version history (you can browse the complete repo for a certain point in the history and link the specific (license) status). But I believe, if you forked it into your own repo, this is not necessary anymore because you don't touch it, right?
  * But pointing to a specific commit is necessary if you took something from a repo system you don't have an account (Gitlab, Bitbucket, ...)
## Create a new type of ``ToolLicenseEntry``
* If might be necessary, that the described classes are not enough for a specific use case
* Please check the hierarchy and find the most fitting point:
  * e.g. every digital source currently inherits from ``_ToolLicensePublicDigitalSource``
* add a ``String`` wrapper to the method ``toolLicenseTypeString()``
* include the new type into the ``licenses.dart`` routine, which is currently really ugly copy/paste stuff