# callstack.ahk 

[![AutoHotkey2](https://img.shields.io/badge/Language-AutoHotkey2-green?style=plastic&logo=autohotkey)](https://autohotkey.com/)
[![Documentation]((https://img.shields.io/badge/Full-Documentation-blue?style=plastic&logo=readthedocs)](https://autohotkey-v2.github.io/callstack.ahk/)

<sub><sup>This library uses [AutoHotkey Version 2](https://autohotkey.com/v2/). (Tested with [AHK v2.0-beta.1 x64 Unicode](https://www.autohotkey.com/boards/viewtopic.php?f=24&t=93011))</sup></sub>

Function to get the current callstack, containing information like functionname, filename and linenumber of the function.

## Installation

In a terminal or command line navigate to your project folder and type following command:
```bash
npm install AutoHotkey-V2/callstack.ahk.git
```

## Usage

Include `export.ahk` from the `callstack.ahk` folder into your project using standard AutoHotkey-include methods.

```autohotkey
#Include %A_ScriptDir%\node_modules\callstack.ahk\export.ahk

foo()
return

foo(){
	cs := CallStack()
	# Print the current callstack
	for level, obj in  CallStack() {
		if (A_Index > 1 )
			str := str . " => "
		str := str . obj.function
	}
	OutputDebug str
}
```

For usage examples have a look at the files in the *examples* folder.

For more detailed documentation have a look into the [full documentation](https://autohotkey-v2.github.io/callstack.ahk/)