render = ->
  $(".pagenation").hide()
  $("#messages .page").infinitescroll
    #debug : true
    loading: {
      img:     "http://www.mytreedb.com/uploads/mytreedb/loader/ajax_loader_blue_48.gif"
      msgText: "ロード中..."
      finishedMsg: "全データ読み込み終了"
    }
    navSelector: ".pagination"
    nextSelector: ".pagination a[rel=next]"
    itemSelector: "#messages div.messages-item"
    state:
      isPaused: false

$(document).on('turbolinks:render', render)
$(document).on('turbolinks:load', render)

$(document).on 'turbolinks:before-render', ->
  $("#messages .page").infinitescroll('pause')
