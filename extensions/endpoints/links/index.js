"use strict";var e=(e,{services:s,exceptions:c})=>{const{ItemsService:n}=s,{ServiceUnavailableException:t}=c;e.get("/",(async(e,s,c)=>{new n("links").readByQuery().then((e=>s.json(e))).catch((e=>c(new t(e.message))))}))};module.exports=e;