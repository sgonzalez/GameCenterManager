***
删除了原prom中的GKMatchmakerViewController分类，修正了6.0设备上crash的问题
***
GameCenterManager is a simple singleton class that has methods for authentication, leaderboard score reporting, achievement reporting, as well as achievement and leaderboard view displaying! There is even a category included for making a GKMatchmakerViewController landscape! Note that your project must link against the GameCenter framework.

Usage.m is a file showing the usage of this class, this is NOT a proper class implementation.

There is no attribution required but is greatly appreciated!

Thanks for downloading,
Santiago




Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software in binary form, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.




(Uses Matt Gallagher's SynthesizeSingleton macro, http://cocoawithlove.com/2008/11/singletons-appdelegates-and-top-level.html)