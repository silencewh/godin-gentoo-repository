# Introduction #

For now this Gentoo Repository is just a copy of my local overlay/repository.

# Disclaimer #

You can use it on your own risk without any warranty.

# Paludis #

I use Paludis instead of Portage, so here is instructions for Paludis.
You can read more about Paludis from [official site](http://paludis.pioto.org/).

## Add repository ##

Create file **/etc/paludis/repositories/godin.conf** :
```
importance = 20
location = ${ROOT}/var/paludis/repositories/godin
sync = svn+http://godin-gentoo-repository.googlecode.com/svn/trunk/repository/
format = ebuild
names_cache = ${location}/.cache/names
write_cache = ${location}/.cache/metadata
```

Sync :
```
mkdir -p /var/paludis/repositories/godin/.cache/{metadata,names}
paludis --sync x-godin
```

Optionally you can unmask everything from this repository by adding following line to **/etc/paludis/keywords.conf** :
```
*/*::godin ~x86
```

## Useful stuff ##

  * [Miscellaneous scripts related to Paludis.](http://git.pioto.org/gitweb/paludis-scripts.git)

# Layman #

Since I don't use Layman, it wasn't tested.

```
layman -f -o http://godin-gentoo-repository.googlecode.com/svn/trunk/layman.xml -a godin
```
or edit your **/etc/layman/layman.cfg** and add new overlay list :
```
overlays  : http://www.gentoo.org/proj/en/overlays/layman-global.txt
            http://godin-gentoo-repository.googlecode.com/svn/trunk/layman.xml
```

Add to sync list :
```
layman -S
layman -L
layman -a godin
```