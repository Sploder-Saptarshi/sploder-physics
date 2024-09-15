package com.sploder.asui
{
   import flash.utils.Dictionary;
   
   public class StringUtils
   {
      public static const HTML_SPECIALCHARS:uint = 0;
      
      public static const HTML_ENTITIES:uint = 1;
      
      public static const ENT_NOQUOTES:uint = 2;
      
      public static const ENT_COMPAT:uint = 3;
      
      public static const ENT_QUOTES:uint = 4;
      
      public static var monthNames:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
      
      public static var monthShortNames:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
      
      public static var dayNames:Array = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
      
      private static var pattern:Array = new Array(29);
      
      private static var patternReplace:Array = ["S","Oe","Z","s","oe","z","A","Ae","C","E","I","D","N","O","U","Y","Th","ss","a","ae","c","e","i","d","n","o","u","y","th"];
      
      pattern[0] = /Š/g;
      pattern[1] = /Œ/g;
      pattern[2] = /Ž/g;
      pattern[3] = /š/g;
      pattern[4] = /œ/g;
      pattern[5] = /ž/g;
      pattern[6] = /[ÀÁÂÃÄÅ]/g;
      pattern[7] = /Æ/g;
      pattern[8] = /Ç/g;
      pattern[9] = /[ÈÉÊË]/g;
      pattern[10] = /[ÌÍÎÏ]/g;
      pattern[11] = /Ð/g;
      pattern[12] = /Ñ/g;
      pattern[13] = /[ÒÓÔÕÖØ]/g;
      pattern[14] = /[ÙÚÛÜ]/g;
      pattern[15] = /[ŸÝ]/g;
      pattern[16] = /Þ/g;
      pattern[17] = /ß/g;
      pattern[18] = /[àáâãäå]/g;
      pattern[19] = /æ/g;
      pattern[20] = /ç/g;
      pattern[21] = /[èéêë]/g;
      pattern[22] = /[ìíîï]/g;
      pattern[23] = /ð/g;
      pattern[24] = /ñ/g;
      pattern[25] = /[òóôõöø]/g;
      pattern[26] = /[ùúûü]/g;
      pattern[27] = /[ýÿ]/g;
      pattern[28] = /þ/g;
      
      public function StringUtils()
      {
         super();
      }
      
      public static function prettydatestring(param1:Date) : String
      {
         return dayNames[param1.getDay()] + ", " + monthNames[param1.getMonth()] + " " + param1.getDate() + ", " + param1.getFullYear();
      }
      
      public static function cgidatestring(param1:Date) : String
      {
         var _loc2_:String = "" + param1.getDate();
         if(param1.getDate() < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         var _loc3_:String = "" + param1.getMonth() + 1;
         if(param1.getMonth() + 1 < 10)
         {
            _loc3_ = "0" + _loc3_;
         }
         var _loc4_:String = "" + param1.getFullYear();
         return _loc3_ + "." + _loc2_ + "." + _loc4_;
      }
      
      public static function removeHTML(param1:String) : String
      {
         var _loc2_:RegExp = /<[^>]*>/g;
         return param1.replace(_loc2_,"");
      }
      
      public static function clean(param1:String) : String
      {
         param1 = decomposeUnicode(param1);
         param1 = param1.toLowerCase().split(" ").join("_");
         var _loc2_:RegExp = /[^a-z0-9_]/g;
         return param1.replace(_loc2_,"").split("__").join("_");
      }
      
      public static function decomposeUnicode(param1:String) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < pattern.length)
         {
            param1 = param1.replace(pattern[_loc2_],patternReplace[_loc2_]);
            _loc2_++;
         }
         return param1;
      }
      
      private static function get_html_translation_table(param1:uint = 0, param2:uint = 3) : Dictionary
      {
         var _loc9_:String = null;
         var _loc3_:Object = {};
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:int = 0;
         var _loc6_:String = "";
         var _loc7_:uint = param1;
         var _loc8_:uint = param2;
         if(_loc7_ !== HTML_SPECIALCHARS && _loc7_ !== HTML_ENTITIES)
         {
            throw new Error("Table: " + _loc7_ + " not supported");
         }
         if(_loc7_ == HTML_ENTITIES)
         {
            _loc3_["160"] = "&nbsp;";
            _loc3_["161"] = "&iexcl;";
            _loc3_["162"] = "&cent;";
            _loc3_["163"] = "&pound;";
            _loc3_["164"] = "&curren;";
            _loc3_["165"] = "&yen;";
            _loc3_["166"] = "&brvbar;";
            _loc3_["167"] = "&sect;";
            _loc3_["168"] = "&uml;";
            _loc3_["169"] = "&copy;";
            _loc3_["170"] = "&ordf;";
            _loc3_["171"] = "&laquo;";
            _loc3_["172"] = "&not;";
            _loc3_["173"] = "&shy;";
            _loc3_["174"] = "&reg;";
            _loc3_["175"] = "&macr;";
            _loc3_["176"] = "&deg;";
            _loc3_["177"] = "&plusmn;";
            _loc3_["178"] = "&sup2;";
            _loc3_["179"] = "&sup3;";
            _loc3_["180"] = "&acute;";
            _loc3_["181"] = "&micro;";
            _loc3_["182"] = "&para;";
            _loc3_["183"] = "&middot;";
            _loc3_["184"] = "&cedil;";
            _loc3_["185"] = "&sup1;";
            _loc3_["186"] = "&ordm;";
            _loc3_["187"] = "&raquo;";
            _loc3_["188"] = "&frac14;";
            _loc3_["189"] = "&frac12;";
            _loc3_["190"] = "&frac34;";
            _loc3_["191"] = "&iquest;";
            _loc3_["192"] = "&Agrave;";
            _loc3_["193"] = "&Aacute;";
            _loc3_["194"] = "&Acirc;";
            _loc3_["195"] = "&Atilde;";
            _loc3_["196"] = "&Auml;";
            _loc3_["197"] = "&Aring;";
            _loc3_["198"] = "&AElig;";
            _loc3_["199"] = "&Ccedil;";
            _loc3_["200"] = "&Egrave;";
            _loc3_["201"] = "&Eacute;";
            _loc3_["202"] = "&Ecirc;";
            _loc3_["203"] = "&Euml;";
            _loc3_["204"] = "&Igrave;";
            _loc3_["205"] = "&Iacute;";
            _loc3_["206"] = "&Icirc;";
            _loc3_["207"] = "&Iuml;";
            _loc3_["208"] = "&ETH;";
            _loc3_["209"] = "&Ntilde;";
            _loc3_["210"] = "&Ograve;";
            _loc3_["211"] = "&Oacute;";
            _loc3_["212"] = "&Ocirc;";
            _loc3_["213"] = "&Otilde;";
            _loc3_["214"] = "&Ouml;";
            _loc3_["215"] = "&times;";
            _loc3_["216"] = "&Oslash;";
            _loc3_["217"] = "&Ugrave;";
            _loc3_["218"] = "&Uacute;";
            _loc3_["219"] = "&Ucirc;";
            _loc3_["220"] = "&Uuml;";
            _loc3_["221"] = "&Yacute;";
            _loc3_["222"] = "&THORN;";
            _loc3_["223"] = "&szlig;";
            _loc3_["224"] = "&agrave;";
            _loc3_["225"] = "&aacute;";
            _loc3_["226"] = "&acirc;";
            _loc3_["227"] = "&atilde;";
            _loc3_["228"] = "&auml;";
            _loc3_["229"] = "&aring;";
            _loc3_["230"] = "&aelig;";
            _loc3_["231"] = "&ccedil;";
            _loc3_["232"] = "&egrave;";
            _loc3_["233"] = "&eacute;";
            _loc3_["234"] = "&ecirc;";
            _loc3_["235"] = "&euml;";
            _loc3_["236"] = "&igrave;";
            _loc3_["237"] = "&iacute;";
            _loc3_["238"] = "&icirc;";
            _loc3_["239"] = "&iuml;";
            _loc3_["240"] = "&eth;";
            _loc3_["241"] = "&ntilde;";
            _loc3_["242"] = "&ograve;";
            _loc3_["243"] = "&oacute;";
            _loc3_["244"] = "&ocirc;";
            _loc3_["245"] = "&otilde;";
            _loc3_["246"] = "&ouml;";
            _loc3_["247"] = "&divide;";
            _loc3_["248"] = "&oslash;";
            _loc3_["249"] = "&ugrave;";
            _loc3_["250"] = "&uacute;";
            _loc3_["251"] = "&ucirc;";
            _loc3_["252"] = "&uuml;";
            _loc3_["253"] = "&yacute;";
            _loc3_["254"] = "&thorn;";
            _loc3_["255"] = "&yuml;";
         }
         if(_loc8_ !== ENT_NOQUOTES)
         {
            _loc3_["34"] = "&quot;";
         }
         if(_loc8_ == ENT_QUOTES)
         {
            _loc3_["39"] = "&#39;";
         }
         _loc3_["60"] = "&lt;";
         _loc3_["62"] = "&gt;";
         for(_loc9_ in _loc3_)
         {
            _loc6_ = String.fromCharCode(parseInt(_loc9_));
            _loc4_[_loc6_] = _loc3_[_loc9_];
         }
         return _loc4_;
      }
      
      public static function html_entity_decode(param1:String, param2:uint = 3) : String
      {
         var _loc3_:Dictionary = null;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         _loc5_ = param1.toString();
         _loc3_ = get_html_translation_table(HTML_ENTITIES,param2);
         if(_loc3_ == null)
         {
            return "";
         }
         for(_loc4_ in _loc3_)
         {
            _loc6_ = _loc3_[_loc4_];
            _loc5_ = _loc5_.split(_loc6_).join(_loc4_);
         }
         return _loc5_.split("&#039;").join("\'");
      }
      
      public static function htmlentities(param1:String, param2:uint = 3) : String
      {
         var _loc3_:Dictionary = null;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         _loc5_ = param1.toString();
         _loc5_ = _loc5_.split("&").join("&amp;");
         _loc3_ = get_html_translation_table(HTML_ENTITIES,param2);
         if(_loc3_ == null)
         {
            return "";
         }
         _loc3_["\'"] = "&#039;";
         for(_loc4_ in _loc3_)
         {
            _loc6_ = _loc3_[_loc4_];
            _loc5_ = _loc5_.split(_loc4_).join(_loc6_);
         }
         return _loc5_;
      }
      
      public static function htmlspecialchars(param1:String, param2:uint = 3) : String
      {
         var _loc3_:Dictionary = null;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         _loc5_ = param1.toString();
         _loc5_ = _loc5_.split("&").join("&amp;");
         _loc3_ = get_html_translation_table(HTML_SPECIALCHARS,param2);
         if(_loc3_ == null)
         {
            return "";
         }
         _loc3_["\'"] = "&#039;";
         for(_loc4_ in _loc3_)
         {
            _loc6_ = _loc3_[_loc4_];
            _loc5_ = _loc5_.split(_loc4_).join(_loc6_);
         }
         return _loc5_;
      }
      
      public static function htmlspecialchars_decode(param1:String, param2:uint = 3) : String
      {
         var _loc3_:Dictionary = null;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         _loc5_ = param1.toString();
         _loc3_ = get_html_translation_table(HTML_SPECIALCHARS,param2);
         if(_loc3_ == null)
         {
            return "";
         }
         for(_loc4_ in _loc3_)
         {
            _loc6_ = _loc3_[_loc4_];
            _loc5_ = _loc5_.split(_loc6_).join(_loc4_);
         }
         return _loc5_.split("&#039;").join("\'");
      }
   }
}

