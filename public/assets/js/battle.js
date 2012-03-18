$(function () {
  $('.haiku').click(function () {
    var $this = $(this),
        haikus = $('.haiku'),
        winnerIndex = haikus.index($this);
        $loser = $(haikus[winnerIndex === 1 ? 0 : 1]);

        $('#battle-report input[name="win"]').val($this.data('id'));
        $('#battle-report input[name="loss"]').val($loser.data('id'));
        $('#battle-report').submit();
  });
});
