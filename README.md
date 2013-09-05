Identicon
=========
![](https://dl.dropboxusercontent.com/u/262919/Identicons/1.png)
![](https://dl.dropboxusercontent.com/u/262919/Identicons/2.png)
![](https://dl.dropboxusercontent.com/u/262919/Identicons/3.png)

A Ruby library that generates GitHub-like [identicons](https://github.com/blog/1586-identicons)

## Installing

That's easy! Use [RubyGems](http://rubygems.org)!

Insert `Identicon` on your application's Gemfile:

	gem `identicon`

and run

	$ bundle

or manually install it typing

	$ gem install identicon

and hitting `return` with your favourite finger.




## Using

Require it as always

	require 'identicon'

Now you can use it through two methods: `data_url_for` or `file_for`. Simple like that.

## `data_url_for`
This generates a data-url, so you can use it immediately, check it out:

	Identicon.data_url_for "Whatever you want!"

You can also specify a image size and a background color:

	Identicon.data_url_for "Whatever you want!", 128, [255, 255, 255]

This creates a 128x128px image, with a nice white background.

---------

*But Vito, I want to save it as a file.*

No probs! 

# `file_for`
This generates and writes the result to a file. It's as easy as just making a data-url. Check it out:

	Identicon.file_for "User's email? Username? Telephone?", "/path/to/the/image"

And, as you may guess, it also takes that optional parameters.

	Identicon.file_for "User's email? Username? Telephone?", "/path/to/the/image", 128, [255, 255, 255]

----------

Pull requests are welcome!