var Module=typeof pyodide._module!=="undefined"?pyodide._module:{};Module.checkABI(1);if(!Module.expectedDataFileDownloads){Module.expectedDataFileDownloads=0;Module.finishedDataFileDownloads=0}Module.expectedDataFileDownloads++;(function(){var loadPackage=function(metadata){var PACKAGE_PATH;if(typeof window==="object"){PACKAGE_PATH=window["encodeURIComponent"](window.location.pathname.toString().substring(0,window.location.pathname.toString().lastIndexOf("/"))+"/")}else if(typeof location!=="undefined"){PACKAGE_PATH=encodeURIComponent(location.pathname.toString().substring(0,location.pathname.toString().lastIndexOf("/"))+"/")}else{throw"using preloaded data can only be done on a web page or in a web worker"}var PACKAGE_NAME="electionguard.data";var REMOTE_PACKAGE_BASE="electionguard.data";if(typeof Module["locateFilePackage"]==="function"&&!Module["locateFile"]){Module["locateFile"]=Module["locateFilePackage"];err("warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)")}var REMOTE_PACKAGE_NAME=Module["locateFile"]?Module["locateFile"](REMOTE_PACKAGE_BASE,""):REMOTE_PACKAGE_BASE;var REMOTE_PACKAGE_SIZE=metadata.remote_package_size;var PACKAGE_UUID=metadata.package_uuid;function fetchRemotePackage(packageName,packageSize,callback,errback){var xhr=new XMLHttpRequest;xhr.open("GET",packageName,true);xhr.responseType="arraybuffer";xhr.onprogress=function(event){var url=packageName;var size=packageSize;if(event.total)size=event.total;if(event.loaded){if(!xhr.addedTotal){xhr.addedTotal=true;if(!Module.dataFileDownloads)Module.dataFileDownloads={};Module.dataFileDownloads[url]={loaded:event.loaded,total:size}}else{Module.dataFileDownloads[url].loaded=event.loaded}var total=0;var loaded=0;var num=0;for(var download in Module.dataFileDownloads){var data=Module.dataFileDownloads[download];total+=data.total;loaded+=data.loaded;num++}total=Math.ceil(total*Module.expectedDataFileDownloads/num);if(Module["setStatus"])Module["setStatus"]("Downloading data... ("+loaded+"/"+total+")")}else if(!Module.dataFileDownloads){if(Module["setStatus"])Module["setStatus"]("Downloading data...")}};xhr.onerror=function(event){throw new Error("NetworkError for: "+packageName)};xhr.onload=function(event){if(xhr.status==200||xhr.status==304||xhr.status==206||xhr.status==0&&xhr.response){var packageData=xhr.response;callback(packageData)}else{throw new Error(xhr.statusText+" : "+xhr.responseURL)}};xhr.send(null)}function handleError(error){console.error("package error:",error)}var fetchedCallback=null;var fetched=Module["getPreloadedPackage"]?Module["getPreloadedPackage"](REMOTE_PACKAGE_NAME,REMOTE_PACKAGE_SIZE):null;if(!fetched)fetchRemotePackage(REMOTE_PACKAGE_NAME,REMOTE_PACKAGE_SIZE,function(data){if(fetchedCallback){fetchedCallback(data);fetchedCallback=null}else{fetched=data}},handleError);function runWithFS(){function assert(check,msg){if(!check)throw msg+(new Error).stack}Module["FS_createPath"]("/","lib",true,true);Module["FS_createPath"]("/lib","python3.8",true,true);Module["FS_createPath"]("/lib/python3.8","site-packages",true,true);Module["FS_createPath"]("/lib/python3.8/site-packages","electionguard",true,true);Module["FS_createPath"]("/lib/python3.8/site-packages","electionguard-1.1.15-py3.8.egg-info",true,true);Module["FS_createPath"]("/lib/python3.8/site-packages","electionguardtest",true,true);function DataRequest(start,end,audio){this.start=start;this.end=end;this.audio=audio}DataRequest.prototype={requests:{},open:function(mode,name){this.name=name;this.requests[name]=this;Module["addRunDependency"]("fp "+this.name)},send:function(){},onload:function(){var byteArray=this.byteArray.subarray(this.start,this.end);this.finish(byteArray)},finish:function(byteArray){var that=this;Module["FS_createPreloadedFile"](this.name,null,byteArray,true,true,function(){Module["removeRunDependency"]("fp "+that.name)},function(){if(that.audio){Module["removeRunDependency"]("fp "+that.name)}else{err("Preloading file "+that.name+" failed")}},false,true);this.requests[this.name]=null}};function processPackageData(arrayBuffer){Module.finishedDataFileDownloads++;assert(arrayBuffer,"Loading data file failed.");assert(arrayBuffer instanceof ArrayBuffer,"bad input to processPackageData");var byteArray=new Uint8Array(arrayBuffer);var curr;var compressedData={data:null,cachedOffset:226789,cachedIndexes:[-1,-1],cachedChunks:[null,null],offsets:[0,1244,2629,3843,5138,6232,7367,8602,9795,10993,12106,13145,14378,15601,16706,17900,19034,20113,21228,22205,23418,24417,25177,26163,27168,27902,28991,29833,30935,31911,32818,33978,35325,36442,37385,38534,39583,40650,41728,42869,44017,45214,46267,47231,48297,49105,50091,51121,52154,53185,54161,54997,55971,56874,57825,58766,59752,60857,61854,62949,63935,65029,65916,66976,68148,68980,69784,70461,71335,72590,73895,75072,76061,77172,78389,79778,80819,81516,82559,83805,84727,85597,86418,87345,88246,89363,90465,91439,92578,93809,94994,96280,97256,98461,99555,100619,101853,103071,104261,105267,106497,107843,109099,111060,112315,113247,114133,115069,115860,117035,118070,118914,119729,120686,121691,122587,123528,124571,125643,126935,128317,129415,130345,131315,132260,133303,134290,135117,135981,136699,137617,138363,139509,140252,141287,142657,143963,144954,146118,147335,148514,149749,150691,151628,152768,153923,154996,156024,157230,158209,159349,160345,161540,162720,163964,165003,165922,166809,167694,168610,169408,170333,171213,172151,173031,173877,174776,175676,176582,177439,178368,179262,180141,181041,181973,182818,183718,184555,185453,186298,187205,188064,188956,189785,190681,191568,192427,193378,194265,195258,196330,197799,199093,200370,201242,202149,203184,204263,205213,206206,207423,208396,209452,210679,211871,212940,214093,215239,216422,217570,218703,219758,220559,221675,222602,223333,224463,225387,226676],sizes:[1244,1385,1214,1295,1094,1135,1235,1193,1198,1113,1039,1233,1223,1105,1194,1134,1079,1115,977,1213,999,760,986,1005,734,1089,842,1102,976,907,1160,1347,1117,943,1149,1049,1067,1078,1141,1148,1197,1053,964,1066,808,986,1030,1033,1031,976,836,974,903,951,941,986,1105,997,1095,986,1094,887,1060,1172,832,804,677,874,1255,1305,1177,989,1111,1217,1389,1041,697,1043,1246,922,870,821,927,901,1117,1102,974,1139,1231,1185,1286,976,1205,1094,1064,1234,1218,1190,1006,1230,1346,1256,1961,1255,932,886,936,791,1175,1035,844,815,957,1005,896,941,1043,1072,1292,1382,1098,930,970,945,1043,987,827,864,718,918,746,1146,743,1035,1370,1306,991,1164,1217,1179,1235,942,937,1140,1155,1073,1028,1206,979,1140,996,1195,1180,1244,1039,919,887,885,916,798,925,880,938,880,846,899,900,906,857,929,894,879,900,932,845,900,837,898,845,907,859,892,829,896,887,859,951,887,993,1072,1469,1294,1277,872,907,1035,1079,950,993,1217,973,1056,1227,1192,1069,1153,1146,1183,1148,1133,1055,801,1116,927,731,1130,924,1289,113],successes:[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]};compressedData.data=byteArray;assert(typeof Module.LZ4==="object","LZ4 not present - was your app build with  -s LZ4=1  ?");Module.LZ4.loadPackage({metadata:metadata,compressedData:compressedData});Module["removeRunDependency"]("datafile_electionguard.data")}Module["addRunDependency"]("datafile_electionguard.data");if(!Module.preloadResults)Module.preloadResults={};Module.preloadResults[PACKAGE_NAME]={fromCache:false};if(fetched){processPackageData(fetched);fetched=null}else{fetchedCallback=processPackageData}}if(Module["calledRun"]){runWithFS()}else{if(!Module["preRun"])Module["preRun"]=[];Module["preRun"].push(runWithFS)}};loadPackage({files:[{filename:"/lib/python3.8/site-packages/electionguard/__init__.py",start:0,end:0,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/auxiliary.py",start:0,end:1145,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/ballot.py",start:1145,end:37532,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/ballot_box.py",start:37532,end:40143,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/ballot_store.py",start:40143,end:42201,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/ballot_validator.py",start:42201,end:46283,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/chaum_pedersen.py",start:46283,end:64254,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/data_store.py",start:64254,end:67034,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/decrypt_with_secrets.py",start:67034,end:80789,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/decrypt_with_shares.py",start:80789,end:88528,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/decryption.py",start:88528,end:115210,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/decryption_mediator.py",start:115210,end:127840,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/decryption_share.py",start:127840,end:140380,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/dlog.py",start:140380,end:142174,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/election.py",start:142174,end:178657,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/election_builder.py",start:178657,end:180735,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/election_object_base.py",start:180735,end:181009,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/election_polynomial.py",start:181009,end:185323,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/elgamal.py",start:185323,end:190127,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/encrypt.py",start:190127,end:208281,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/group.py",start:208281,end:222227,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/guardian.py",start:222227,end:242516,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/hash.py",start:242516,end:245819,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/key_ceremony.py",start:245819,end:254917,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/key_ceremony_mediator.py",start:254917,end:269596,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/logs.py",start:269596,end:274622,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/nonces.py",start:274622,end:277021,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/proof.py",start:277021,end:277674,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/publish.py",start:277674,end:281829,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/rsa.py",start:281829,end:283604,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/scheduler.py",start:283604,end:284019,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/schema.py",start:284019,end:284961,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/schnorr.py",start:284961,end:287234,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/serializable.py",start:287234,end:294795,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/singleton.py",start:294795,end:295211,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/tally.py",start:295211,end:310159,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/tracker.py",start:310159,end:312204,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/types.py",start:312204,end:312274,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/utils.py",start:312274,end:315015,audio:0},{filename:"/lib/python3.8/site-packages/electionguard/words.py",start:315015,end:386501,audio:0},{filename:"/lib/python3.8/site-packages/electionguard-1.1.15-py3.8.egg-info/PKG-INFO",start:386501,end:398499,audio:0},{filename:"/lib/python3.8/site-packages/electionguard-1.1.15-py3.8.egg-info/SOURCES.txt",start:398499,end:400348,audio:0},{filename:"/lib/python3.8/site-packages/electionguard-1.1.15-py3.8.egg-info/dependency_links.txt",start:400348,end:400349,audio:0},{filename:"/lib/python3.8/site-packages/electionguard-1.1.15-py3.8.egg-info/not-zip-safe",start:400349,end:400350,audio:0},{filename:"/lib/python3.8/site-packages/electionguard-1.1.15-py3.8.egg-info/requires.txt",start:400350,end:400420,audio:0},{filename:"/lib/python3.8/site-packages/electionguard-1.1.15-py3.8.egg-info/top_level.txt",start:400420,end:400452,audio:0},{filename:"/lib/python3.8/site-packages/electionguardtest/__init__.py",start:400452,end:400452,audio:0},{filename:"/lib/python3.8/site-packages/electionguardtest/ballot_factory.py",start:400452,end:406684,audio:0},{filename:"/lib/python3.8/site-packages/electionguardtest/election.py",start:406684,end:428190,audio:0},{filename:"/lib/python3.8/site-packages/electionguardtest/election_factory.py",start:428190,end:438412,audio:0},{filename:"/lib/python3.8/site-packages/electionguardtest/elgamal.py",start:438412,end:439047,audio:0},{filename:"/lib/python3.8/site-packages/electionguardtest/group.py",start:439047,end:440313,audio:0},{filename:"/lib/python3.8/site-packages/electionguardtest/sample_generator.py",start:440313,end:445416,audio:0},{filename:"/lib/python3.8/site-packages/electionguardtest/tally.py",start:445416,end:446638,audio:0}],remote_package_size:230885,package_uuid:"7707cd34-df4e-43cc-b55c-be8c74b34135"})})();