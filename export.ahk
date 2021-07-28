; ===================================================================================
; AHK Version ...: Tested with AHK v2.0-beta.1 x64 Unicode
; Win Version ...: Tested with Windows 10 Enterprise x64
; Authors ........:  * Original - deo (original)
; ...............    * Modifications - hoppfrosch 
; License .......: MIT license (c) [2021] [Johannes Kilian] (https://opensource.org/licenses/MIT)
; Source ........: Original: https://autohotkey.com/board/topic/76062-ahk-l-how-to-get-callstack-solution/
; ................ V2 : https://github.com/AutoHotkey-V2/callstack.ahk
; ===================================================================================


/*
Name: CallStack - Gets the current call stack

Version 0.1.0

Description:
	Gets the current callstack, containing information like functionname, filename and linenumber of the function.
	A map is returned, containing map elements in range of 0 to -calldepth (negative numbers). 
	Index 0 contains the info about current function, whereas Index -1 contains info about the parent (caller) 
	of the current function. (-2: Grandparent ...)

Example:
	cs := CallStack()
	# Print the current callstack
	for level, obj in  CallStack() { 
		if (A_Index > 1 )
			str := str . " => "
		str := str . obj.function	
	}
	MsgBox str

Parameter:
	* deepness (optional, default := 100) - determines the depth of the determined callstack
	* getContents (optional, default := true) - get the contents of the line, where the current function is called
*/
CallStack(deepness :=100, getContents := true) {
	stack := Map()
	max := 0
	loop deepness {
		lvl := -1 - deepness + A_Index
		oEx := Error("", lvl)
		oExPrev := Error("", lvl - 1)
			
		if (getContents) { ; Get the corresponding line from the file
			file := FileOpen(oEx.file, "r")
			loop {
				if (file.AtEOF)
					break
				line := File.ReadLine() 
				if (A_Index == oEx.line)
					break
			}
			file.close()
		}
		
		if(oEx.What == lvl)
			continue
			
		currStack := {}			
		currStack.file := oEx.File
		currStack.line := oEx.Line
		; currStack.function := (oExPrev.What = lvl-1 ? "[AUTO-EXECUTE]" :  oExPrev.What)
		currStack.function := oExPrev.What
		currStack.depth := deepness - A_Index
		if (max < currStack.depth) {
			max :=  currStack.depth
		}
		if (getContents) {
			currStack.contents := line
		}
		stack[lvl+1] := currStack
	}
	minDepth := 0
	for key,value in stack {
		stack[key].depth := max - stack[key].depth -1
		if (minDepth > key) {
			minDepth := key 
		}
	}
	stack.delete(minDepth)
	return stack
}