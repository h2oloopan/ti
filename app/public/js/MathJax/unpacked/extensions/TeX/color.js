MathJax.Extension["TeX/color"]={version:"2.4.0",config:MathJax.Hub.CombineConfig("TeX.color",{padding:"5px",border:"2px"}),colors:{Apricot:"#FBB982",Aquamarine:"#00B5BE",Bittersweet:"#C04F17",Black:"#221E1F",Blue:"#2D2F92",BlueGreen:"#00B3B8",BlueViolet:"#473992",BrickRed:"#B6321C",Brown:"#792500",BurntOrange:"#F7921D",CadetBlue:"#74729A",CarnationPink:"#F282B4",Cerulean:"#00A2E3",CornflowerBlue:"#41B0E4",Cyan:"#00AEEF",Dandelion:"#FDBC42",DarkOrchid:"#A4538A",Emerald:"#00A99D",ForestGreen:"#009B55",Fuchsia:"#8C368C",Goldenrod:"#FFDF42",Gray:"#949698",Green:"#00A64F",GreenYellow:"#DFE674",JungleGreen:"#00A99A",Lavender:"#F49EC4",LimeGreen:"#8DC73E",Magenta:"#EC008C",Mahogany:"#A9341F",Maroon:"#AF3235",Melon:"#F89E7B",MidnightBlue:"#006795",Mulberry:"#A93C93",NavyBlue:"#006EB8",OliveGreen:"#3C8031",Orange:"#F58137",OrangeRed:"#ED135A",Orchid:"#AF72B0",Peach:"#F7965A",Periwinkle:"#7977B8",PineGreen:"#008B72",Plum:"#92268F",ProcessBlue:"#00B0F0",Purple:"#99479B",RawSienna:"#974006",Red:"#ED1B23",RedOrange:"#F26035",RedViolet:"#A1246B",Rhodamine:"#EF559F",RoyalBlue:"#0071BC",RoyalPurple:"#613F99",RubineRed:"#ED017D",Salmon:"#F69289",SeaGreen:"#3FBC9D",Sepia:"#671800",SkyBlue:"#46C5DD",SpringGreen:"#C6DC67",Tan:"#DA9D76",TealBlue:"#00AEB3",Thistle:"#D883B7",Turquoise:"#00B4CE",Violet:"#58429B",VioletRed:"#EF58A0",White:"#FFFFFF",WildStrawberry:"#EE2967",Yellow:"#FFF200",YellowGreen:"#98CC70",YellowOrange:"#FAA21A"},getColor:function(e,r){e||(e="named");var t=this["get_"+e];return t||this.TEX.Error(["UndefinedColorModel","Color model '%1' not defined",e]),t.call(this,r)},get_rgb:function(e){e=e.replace(/^\s+/,"").replace(/\s+$/,"").split(/\s*,\s*/);var r="#";3!==e.length&&this.TEX.Error(["ModelArg1","Color values for the %1 model require 3 numbers","rgb"]);for(var t=0;3>t;t++){e[t].match(/^(\d+(\.\d*)?|\.\d+)$/)||this.TEX.Error(["InvalidDecimalNumber","Invalid decimal number"]);var o=parseFloat(e[t]);(0>o||o>1)&&this.TEX.Error(["ModelArg2","Color values for the %1 model must be between %2 and %3","rgb",0,1]),o=Math.floor(255*o).toString(16),o.length<2&&(o="0"+o),r+=o}return r},get_RGB:function(e){e=e.replace(/^\s+/,"").replace(/\s+$/,"").split(/\s*,\s*/);var r="#";3!==e.length&&this.TEX.Error(["ModelArg1","Color values for the %1 model require 3 numbers","RGB"]);for(var t=0;3>t;t++){e[t].match(/^\d+$/)||this.TEX.Error(["InvalidNumber","Invalid number"]);var o=parseInt(e[t]);o>255&&this.TEX.Error(["ModelArg2","Color values for the %1 model must be between %2 and %3","RGB",0,255]),o=o.toString(16),o.length<2&&(o="0"+o),r+=o}return r},get_gray:function(e){e.match(/^\s*(\d+(\.\d*)?|\.\d+)\s*$/)||this.TEX.Error(["InvalidDecimalNumber","Invalid decimal number"]);var r=parseFloat(e);return(0>r||r>1)&&this.TEX.Error(["ModelArg2","Color values for the %1 model must be between %2 and %3","gray",0,1]),r=Math.floor(255*r).toString(16),r.length<2&&(r="0"+r),"#"+r+r+r},get_named:function(e){return this.colors[e]?this.colors[e]:e},padding:function(){var e="+"+this.config.padding,r=this.config.padding.replace(/^.*?([a-z]*)$/,"$1"),t="+"+2*parseFloat(e)+r;return{width:t,height:e,depth:e,lspace:this.config.padding}}},MathJax.Hub.Register.StartupHook("TeX Jax Ready",function(){var e=MathJax.InputJax.TeX,r=MathJax.ElementJax.mml,t=e.Stack.Item,o=MathJax.Extension["TeX/color"];o.TEX=e,e.Definitions.Add({macros:{color:"Color",textcolor:"TextColor",definecolor:"DefineColor",colorbox:"ColorBox",fcolorbox:"fColorBox"}},null,!0),e.Parse.Augment({Color:function(e){var r=this.GetBrackets(e),n=this.GetArgument(e);n=o.getColor(r,n);var a=t.style().With({styles:{mathcolor:n}});this.stack.env.color=n,this.Push(a)},TextColor:function(e){var t=this.GetBrackets(e),n=this.GetArgument(e);n=o.getColor(t,n);var a=this.stack.env.color;this.stack.env.color=n;var l=this.ParseArg(e);a?this.stack.env.color:delete this.stack.env.color,this.Push(r.mstyle(l).With({mathcolor:n}))},DefineColor:function(e){var r=this.GetArgument(e),t=this.GetArgument(e),n=this.GetArgument(e);o.colors[r]=o.getColor(t,n)},ColorBox:function(e){var t=this.GetArgument(e),n=this.InternalMath(this.GetArgument(e));this.Push(r.mpadded.apply(r,n).With({mathbackground:o.getColor("named",t)}).With(o.padding()))},fColorBox:function(e){var t=this.GetArgument(e),n=this.GetArgument(e),a=this.InternalMath(this.GetArgument(e));this.Push(r.mpadded.apply(r,a).With({mathbackground:o.getColor("named",n),style:"border: "+o.config.border+" solid "+o.getColor("named",t)}).With(o.padding()))}}),MathJax.Hub.Startup.signal.Post("TeX color Ready")}),MathJax.Ajax.loadComplete("[MathJax]/extensions/TeX/color.js");