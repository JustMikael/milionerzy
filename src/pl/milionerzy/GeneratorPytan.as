package pl.milionerzy 
{
	import mx.collections.XMLListCollection;
	
	import spark.collections.Sort;
	/**
	 * ...
	 * @author Michal
	 */
	public class GeneratorPytan 
	{
		[Embed(source="pytania.xml", mimeType="application/octet-stream")]
		public var Pytania:Class;
		
		private function shuffle(coll:XMLListCollection):XMLListCollection
		{
			var ret:XMLListCollection = new XMLListCollection();
			
			while (ret.length < 3)
			{
				var r:int = Math.random() * coll.length;
				var xml:XML = coll.getItemAt(r) as XML;
				
				if (xml.@correct == 'true')
					continue;
				
				ret.addItem(xml);
				coll.removeItemAt(r);
			}
			
			var correct:XML = coll.source.(attribute('correct') == 'true')[0];
			ret.addItemAt(correct, Math.random() * 4);
			
			return ret;
		}
		
		public function wylosujPytanie(aktualnePytanie:int):Pytanie
		{
			aktualnePytanie = (aktualnePytanie - 1) * 10/15 + 1;
			
			var pytania:String = new Pytania();
			
			var xml:XML = new XML(pytania);
			
			var listaPytan:XMLList = xml.pytanie.(@kategoria == aktualnePytanie);
			
			var len:int = listaPytan.length();
			
			var index:int = Math.random() * len;
			
			var pytanieXml:XML = listaPytan[index];
			
			var pyt:Pytanie = new Pytanie();
			pyt.tekst = pytanieXml.@tekst;
			
			var listaOdpowiedzi:XMLListCollection = new XMLListCollection(pytanieXml.odp);
			listaOdpowiedzi = shuffle(listaOdpowiedzi);
			pyt.odpowiedzi = [listaOdpowiedzi.getItemAt(0).toString(), listaOdpowiedzi.getItemAt(1).toString(), listaOdpowiedzi.getItemAt(2).toString(), listaOdpowiedzi.getItemAt(3).toString()];
			
			for (var i:int = 0; i < 4; ++i )
			{
				if (listaOdpowiedzi[i].@correct == "true")
					pyt.poprawna = i;
			}
			
			return pyt;
		}
		
		public function GeneratorPytan() 
		{
			
		}
		
	}

}