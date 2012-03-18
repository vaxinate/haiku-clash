$(function () {
  $('textarea').each(function () {
    var $this = $(this),
        newValue = $this.text().replace(/<br>/g, '\n');
    $this.text(newValue);
  });
});
