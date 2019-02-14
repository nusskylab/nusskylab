/*! Parser: dates - updated 10/26/2014 (v2.18.0) */
!function(e){"use strict";/*! Sugar (http://sugarjs.com/dates#comparing_dates) */
e.tablesorter.addParser({id:"sugar",is:function(){return!1},format:function(e){var t=Date.create?Date.create(e):e?new Date(e):e;return t instanceof Date&&isFinite(t)?t.getTime():e},type:"numeric"}),/*! Datejs (http://www.datejs.com/) */
e.tablesorter.addParser({id:"datejs",is:function(){return!1},format:function(e){var t=Date.parse?Date.parse(e):e?new Date(e):e;return t instanceof Date&&isFinite(t)?t.getTime():e},type:"numeric"})}(jQuery);