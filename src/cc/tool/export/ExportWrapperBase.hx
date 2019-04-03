package cc.tool.export;

using StringTools;

class ExportWrapperBase {
	// public var imageStringArray:Array<String> = [];
	var _onProgressHandler:Float->Void;
	var _onExportComplete:Dynamic;
	var _isDebug:Bool = false;

	public function new() {
		// trace(toString());
	}

	// ____________________________________ public functions ____________________________________

	public function progress(func:Float->Void) {
		_onProgressHandler = func;
	}

	public function complete(func:Dynamic) {
		_onExportComplete = func;
	}

	// ____________________________________ get export files ____________________________________

	public function getMarkdown(obj:ExportWrapper.ExportWrapperObj):String {
		var md = '# ${toString()}

- Generated on: ${Date.now()}
- total images: ${obj.imageStringArray.length}
- calculated time: ${obj.imageStringArray.length / 60} sec
- file name: `_${obj.filename}_${obj.timestamp}.zip`
- delay: ${obj.delay} frames (${obj.delay / 60} sec)
- record: ${obj.record} frames (${obj.record / 60} sec)

## Instagram

```
sketch.${obj.filename} :: ${obj.description}

#codeart #coding #creativecode #generative #generativeArt
#minimalism #minimalist #minimal
#haxe #javascript #js #nodejs
#animation #illustration #graphicdesign
```

## convert

open terminal

```
sh convert.sh
```

## Folder structure

```
+ _${obj.filename}_${obj.timestamp}.zip
+ _${obj.filename}
	- convert.sh
	- README.MD
	+ sequence
		- image_${Std.string(0).lpad('0', 4)}.png
		- image_${Std.string(1).lpad('0', 4)}.png
		- ...
```
';

		return md;
	}

	public function getBashConvert(obj:ExportWrapper.ExportWrapperObj):String {
		var bash = '#!/bin/bash

echo \'Start convertions png sequence to mp4\'

ffmpeg -y -r 30 -i sequence/image_%04d.png -c:v libx264 -strict -2 -pix_fmt yuv420p -shortest -filter:v "setpts=0.5*PTS"  ${obj.filename}_output_30fps.mp4
# ffmpeg -y -r 30 -i sequence/image_%04d.png -c:v libx264 -strict -2 -pix_fmt yuv420p -shortest -filter:v "setpts=0.5*PTS"  sequence/_output_30fps.mp4

echo \'End convertions png sequence to mp4\'

';

		return bash;
	}

	public function getBashConvertPng(obj:ExportWrapper.ExportWrapperObj):String {
		var bash2 = '
#!/bin/bash

echo \'Start remove transparancy from images sequence\'

cd sequence
mkdir output
for i in *.png; do
   convert "$$i" -background white -alpha remove output/"$$i"
   echo "$$i"
done

echo \'End remove transparancy from images sequence\'
echo \'Start convertions png sequence to mp4\'

ffmpeg -y -r 30 -i output/image_%04d.png -c:v libx264 -strict -2 -pix_fmt yuv420p -shortest -filter:v "setpts=0.5*PTS"  ../${obj.filename}_white_output_30fps.mp4

echo \'End convertions png sequence to mp4\'

';

		return bash2;
	}

	/**
	 * ctivate logs
	 * @param isDebug (default is `false`)
	 */
	public function debug(isDebug:Bool):Void {
		this._isDebug = isDebug;
	}

	public function toString():String {
		return '[ExportTypeBase]';
	}
}
