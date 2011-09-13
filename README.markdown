# Useful ULS #

This is a front-end for searching the US Federal Communication
Commission's [Universal Licensing System][ULS].  The initial scope of
work will encompass the `LMpriv` dataset, as I will be working on
features of primary interest to scanner users.

Desired improvements over the FCC's web interface:

* Improved search speed, especially on geobox searches
* Export of data in a format suitable for scanner programming
* Standing queries (for new licenses/applications matching specified
  parameters)

This application is not intended to interface with any ULS services
requiring a login.

## Other ULS-related projects ##

Wayne Smith N6LHV produced "[A Southern California Guide to the FCC
Universal Licensing System][SOCAL]" in 2008, which I discovered after
starting this project.

## Support ##

To request bug fixes or enhancements, open an issue on the [GitHub
tracker][ISSUE] for this project or email brad@facefault.org.

## License ##

&copy; 2011 Brad Ackerman N1MNB.  This code is licensed under the
[WTFPL][WTF]; the repository also includes copies of [Dojo][DOJO]
([modified BSD or AFL][DOJOL]) and [960.gs][960] (GPL or MIT).

[960]: http://960.gs/
[ISSUE]: https://github.com/backerman/useful-uls/issues
[DOJO]: http://dojotoolkit.org/
[DOJOL]: http://dojotoolkit.org/license
[SOCAL]: http://www.n6lhv.net/uls/
[ULS]: http://wireless.fcc.gov/uls/
[WTF]: http://sam.zoy.org/wtfpl/
