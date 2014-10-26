# Meteor-helper: Call Meteor from Atom.io

:rocket: Launch [Meteor](https://www.meteor.com/)
and [Meteorite](https://atmospherejs.com/) inside [Atom.io](https://atom.io/)

![Meteor.js from Atom.io](https://raw.githubusercontent.com/PEM--/meteor-helper/master/assets/capture.png)

Either use [Atom.io](https://atom.io/) inner packaging tool or the following
command line:
```bash
apm install meteor-helper
```

With this package, you can:
* Launch or kill Meteor using: **CTRL**+**ALT**+**m**
* Watch the Meteor's CLI information in a dedicated pane.
* See Meteor's status in a dedicated status bar.
* When Meteor's status goes wrong, the pane automatically shows up and displays
  the last CLI information.

In the settings, you can customize this package behavior:
* Command and its path. The default is: `/usr/local/bin/meteor`.
* Main listening port. The default is 3000.
* Production flag. The default is `false`.
* Debug flag. The default is `false`.
* MongoDB's URL. Leave it empty to use the default embedded MongoDB in Meteor.
* MongoDB's Oplog URL. Leave it empty to use the default embedded MongoDB in Meteor.
* Customize the color of Meteor's `console.log`.

![Settings](https://raw.githubusercontent.com/PEM--/meteor-helper/master/assets/settings.png)

You can overwrite variable settings with a per project file named `mup.json` at
the root of your project using [Meteor Up](https://github.com/arunoda/meteor-up)
recommendations. The following variables supersedes the settings ones:
* `env.PORT`: Meteor's port.
* `env.MONGO_URL`: MongoDB's URL.
* `env.MONGO_OPLOG_URL`: MongoDB's Oplog URL.

> **Tips**: To create a default Meteor Up project, simply use the following
> commands:
> ```bash
> npm install -g mup
> mup init
> ```
> And removes the unnecessary comments and add the following environment
> variables with your own values:
> ```json
>   "env": {
>     "PORT": 3002,
>     "MONGO_URL": "mongodb://LOGIN:PASSWORD@ACCOUNT.mongohq.com:10023/MyApp",
>   },
> ```

* More informations on my blog site :eyeglasses: : [Meteor.js from within Atom.io](http://pem-musing.blogspot.com/2014/07/meteorjs-from-within-atomio-full-stack.html)
* Declare your bugs :bug: or enhancements :sunny: on
  [Github](https://github.com/PEM--/meteor-helper/issues?state=open) :octocat:
