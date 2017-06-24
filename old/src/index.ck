doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title "Vanity Site for Robert de Forest"

    link rel: 'stylesheet', href: 'css/style.css.text=css'

  body ->
    div class: 'titleBar', ->
      div class: ['leftMenu', 'menu'], ->
        ul ->
          li -> a href: p.link, -> p.text for p in subPages

      div class: ['rightMenu', 'menu'], ->

      div class: 'content', ->
