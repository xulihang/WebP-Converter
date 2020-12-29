B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Sub LoadImage(dir As String,filename As String) As B4XBitmap
	Dim imageio As JavaObject
	imageio.InitializeStatic("javax.imageio.ImageIO")
	Dim reader As JavaObject
	reader=imageio.RunMethodJO("getImageReadersByMIMEType",Array("image/webp")).RunMethod("next",Null)
	Dim readParam As JavaObject
	readParam.InitializeNewInstance("com.luciad.imageio.webp.WebPReadParam",Null)
	readParam.RunMethod("setBypassFiltering",Array(True))
	Dim imgfile As JavaObject
	imgfile.InitializeNewInstance("java.io.File",Array(File.Combine(dir,filename)))
	Dim FileImageInputStream As JavaObject
	FileImageInputStream.InitializeNewInstance("javax.imageio.stream.FileImageInputStream",Array(imgfile))
	reader.RunMethod("setInput",Array(FileImageInputStream))
	Dim Image As JavaObject
	Image=reader.RunMethodJO("read",Array(0, readParam))
	Dim jo As JavaObject
	Return jo.InitializeStatic("javafx.embed.swing.SwingFXUtils").RunMethod("toFXImage", Array(Image,Null))
End Sub

Sub ConvertToWebP(img As B4XBitmap,quality As Float,outputDir As String,outputFilename As String)
	Dim imageio As JavaObject
	imageio.InitializeStatic("javax.imageio.ImageIO")
	Dim writer As JavaObject
	writer=imageio.RunMethodJO("getImageWritersByMIMEType",Array("image/webp")).RunMethod("next",Null)
	Dim writeParam As JavaObject
	writeParam.InitializeNewInstance("com.luciad.imageio.webp.WebPWriteParam",Array(writer.RunMethod("getLocale",Null)))
	writeParam.RunMethod("setCompressionMode",Array(writeParam.GetField("MODE_DEFAULT")))
	'writeParam.RunMethod("setCompressionMode",Array(writeParam.GetField("MODE_EXPLICIT")))
	'Dim compressiontype As String="Lossy"
	'writeParam.RunMethod("setCompressionType",Array(compressiontype))
	'writeParam.RunMethod("setCompressionQuality",Array(quality))
	Dim imgfile As JavaObject
	imgfile.InitializeNewInstance("java.io.File",Array(File.Combine(outputDir,outputFilename)))
	Dim FileImageOutputStream As JavaObject
	FileImageOutputStream.InitializeNewInstance("javax.imageio.stream.FileImageOutputStream",Array(imgfile))
	writer.RunMethod("setOutput",Array(FileImageOutputStream))
	Dim IIOImage As JavaObject
	Dim SwingFXUtils As JavaObject
	SwingFXUtils.InitializeStatic("javafx.embed.swing.SwingFXUtils")
	Dim BufferdImage As JavaObject
	BufferdImage=SwingFXUtils.RunMethod("fromFXImage", Array(img,Null))
	IIOImage.InitializeNewInstance("javax.imageio.IIOImage",Array(BufferdImage,Null,Null))
	writer.RunMethod("write",Array(Null, IIOImage, writeParam))
End Sub
