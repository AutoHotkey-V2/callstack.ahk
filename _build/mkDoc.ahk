#Include %A_ScriptDir%\..\export.ahk  ; Where to get version being used within documentation

; Omit extension ".exe" 
NDPath := GetFullPathName(A_ScriptDir "\..\..\_build\NaturalDocs\NaturalDocs")
GitChglogPath := GetFullPathName(A_ScriptDir "\..\..\_build\git-chglog")

DocuUpdateVersion(release_version(), A_ScriptDir)
DocuGenerate(A_ScriptDir)
ChangelogGenerate(A_ScriptDir)
ExitApp

;-------------------------------------------------------------------------------------------------------------
DocuUpdateVersion(ver, path) {
	; Updates Version (within NaturalDocs project file) within documentation

	NDProjectFile := GetFullPathName(path "\NDProj\project.txt")
	NDProjectFileTmp := NDProjectFile ".tmp"
	fileOut := FileOpen(NDProjectFileTmp, "w")

	fileIn := FileOpen(NDProjectFile,"r")
	while (!fileIn.AtEOF) {
		line := fileIn.ReadLine()
		if (foundPos := RegExMatch(line, "Subtitle\:")) {
			line := "Subtitle: Version " ver
		}
		fileOut.Write(line "`n")
	}

	fileIn.close()
	fileOut.close()
	FileMove NDProjectFileTmp, NDProjectFile, 1
}

;-------------------------------------------------------------------------------------------------------------
DocuGenerate(path) {
	; Generates Documentation using NaturalDocs
	EnvSet "NDPATH", NDPath
	cmd := NDPath " -r -p " path "\NDProj"
	RunWait(cmd)
}

;-------------------------------------------------------------------------------------------------------------
ChangelogGenerate(path) {
	; Generates Changelog using git-chglog - only commits on "export.ahk" are considered
	cmd := GitChglogPath " --path " path "/../export.ahk --output ../CHANGELOG.md --config .chglog/config.yml"
	RunWait(cmd,,"Min")
}

;-------------------------------------------------------------------------------------------------------------
GetFullPathName(Filename) {
	; Determines the fullpath (absolute path) from relative path
	Size := DllCall("Kernel32.dll\GetFullPathNameW", "Str", Filename, "UInt", 0, "Ptr", 0, "PtrP", 0)
	OutputBuff := Buffer(Size * 2)
	r := DllCall("Kernel32.dll\GetFullPathNameW", "Str", Filename, "UInt", Size, "Ptr", OutputBuff, "PtrP", 0)
	ret := ""
	if (r > 0)
		ret := RTrim(StrGet(OutputBuff), "\")
	Else
		ret := Filename
	return ret
}

