($ ->
  showResumeHistoryDiff = (e) ->
    e.preventDefault()
    history = $(this).closest('tr').find('.history_data').data('history')
    $('.edit_history_detail_container').html(history)

  $('.show_resume_history').each((idx, elem) ->
    $(elem).bind('click', showResumeHistoryDiff)
  )
)
