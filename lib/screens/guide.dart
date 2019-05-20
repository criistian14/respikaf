import 'package:flutter/material.dart';


// Libraries
import 'package:flutter_pdf_viewer/flutter_pdf_viewer.dart';


class Guide extends StatefulWidget 
{
	@override
	_GuideState createState() => _GuideState();
}

class _GuideState extends State<Guide> 
{
	final _config = PdfViewerConfig(
		nightMode: false,
		// swipeHorizontal: true
	);


	@override
	Widget build(BuildContext context) 
	{
		return Container(
			child: Column(
				children: <Widget>[
					RaisedButton(
						elevation: 6,
						child: Text('Abrir Manual', style: Theme.of(context).textTheme.display1),
						onPressed: () => PdfViewer.loadAsset('files/guide.pdf', config: _config),
					),

					SizedBox(height: 20),
					RaisedButton(
						elevation: 6,
						child: Text('Descargar Manual', style: Theme.of(context).textTheme.display1),
						onPressed: () => PdfViewer.loadAsset('files/guide.pdf'),
					),
				],
			)
		);
	}
}


