Identicon
=========
[![Dependency Status](https://gemnasium.com/victorgama/identicon.svg)](https://gemnasium.com/victorgama/identicon)

![](http://i.imgur.com/eQeMxCb.png)
![](http://i.imgur.com/8b8Oezd.png)
![](http://i.imgur.com/yaZd7LR.png)

A Ruby library that generates GitHub-like [identicons](https://github.com/blog/1586-identicons)

## Installation

Add it to your application's `Gemfile`:

```ruby
gem 'identicon'
```

and run

    $ bundle

or manually install through the command-line:

    $ gem install identicon

## Usage

Require it
```ruby
require 'identicon'
```

And use `data_url_for` or `file_for`, as explained below:

## `data_url_for`
This generates a data-url, so you can use it immediately, check it out:
```ruby
Identicon.data_url_for "Whatever you want!"
```
You can also specify a image size and a background color:
```ruby
Identicon.data_url_for "Whatever you want!", 128, [255, 255, 255]
```
This creates a 128x128px image, with a nice white background.

# `file_for`
This generates and writes the result to a file. It's as easy as just making a data-url. Check it out:
```ruby
Identicon.file_for "User's email? Username? Telephone?", "/path/to/the/image"
```
And, as you may guess, it also accepts the aforementioned parameters:
```ruby
Identicon.file_for "User's email? Username? Telephone?", "/path/to/the/image", 128, [255, 255, 255]
```
----------

Pull requests are welcome!

## License

```
The MIT License (MIT)

Copyright (c) 2014-2017 Victor Gama

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
