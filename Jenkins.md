[Jenkins](http://jenkins-ci.org/) is extensible continuous integration server.

# Prerequisites #

Configured repository (see [HowTo](HowTo.md)).

# Installation #

Following keywords used to indicate stability of package :
  * x86, amd64 - corresponds to [long-term support release](https://wiki.jenkins-ci.org/display/JENKINS/LTS+Release+Line) ([changelog](http://jenkins-ci.org/changelog-stable))
  * ~x86, ~amd64 - corresponds to release ([changelog](http://jenkins-ci.org/changelog))

If you use cave:
```
cave resolve -x dev-util/jenkins-bin
```

Or using emerge:
```
emerge -av dev-util/jenkins-bin
```

Now you can configure Jenkins:
```
/etc/conf.d/jenkins
```

The only thing left to do is to start:
```
/etc/init.d/jenkins start
```

And, optionally, add it to start at boot:
```
rc-update add jenkins default
```