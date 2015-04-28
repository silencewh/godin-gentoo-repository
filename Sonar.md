[Sonar](http://sonarsource.org) is an ultimate open platform to manage code quality.

# Prerequisites #

Configured repository (see [HowTo](HowTo.md)).

# Installation #

If you use cave:
```
cave resolve -x dev-util/sonar-bin
```

Or using emerge:
```
emerge -av dev-util/sonar-bin
```

The only thing left to do is to start Sonar:
```
/etc/init.d/sonar start
```

And, optionally, add it to start at boot:
```
rc-update add sonar default
```