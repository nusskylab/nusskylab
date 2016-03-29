/*
 * jQuery Autolink
 * jQuery Automail
 *
 * @author Riccardo Mastellone
 * @description Two simple jQuery plugins to detect links (autolink) and email (automail) and make them clickable
 * @usage $(".contaier").automail().autolink();
 */


jQuery.fn.automail = function() {
  return this.each(function() {
    var re = /(([a-z0-9*._+]){1,}\@(([a-z0-9\-]?){1,}[a-z0-9\-]+\.){1,}([a-z]{2,4}|museum)(?![\w\s?&.\/;#~%"=-]*>))/gi;
    $(this).html($(this).html().replace(re, '<a href="mailto:$1">$1</a>'));
  });
};

jQuery.fn.autolink = function() {
  return this.each(function() {
    var re = /(^|\s)(((([^:\/?#\s]+):)?\/\/)?(([A-Za-z0-9-]+\.)+[A-Za-z0-9-]+)(:\d+)?([^?#\s]*)(\?([^#\s]*))?(#(\S*))?)/gi;
    $(this).html($(this).html().replace(re, function(match, optionalWhitespace, uri, scheme, p4, protocol, fqdn, p7, port, path, query, queryVal, fragment, fragId) {
      return (optionalWhitespace ? optionalWhitespace : '') +
          '<a href="' + (protocol ? uri : 'http://' + uri) +
          '" target="_blank">' + uri + '<\/a>';
    }));
  });
};
