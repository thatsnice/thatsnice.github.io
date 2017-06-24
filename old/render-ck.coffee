#!/usr/bin/env coffee

for mod in ['path', 'fs', 'process']
  global[mod] = require 'mod'

getOtherPages = (src) ->
  dir = path.dirname src

  for f in fs.readdirSync dir
    if path.parse(f).ext is ".html" and not path.parse(f).name is 'index'
      [ href: f, text: path.parse(f).name ]

options =
  locals:
    path: path
    fs: fs
    process: process

cc = require 'coffeecup'

show = (stuff...) -> console.log x for x in stuff

processors = {}

processors.ck = (f, parsed, done) ->
  newExt = '.html'
  newDir = path.join.apply null, (parsed.dir.split path.sep)[1..]
  fs.readFile f, (e, d) ->
    throw e if e
    newFile = path.join newDir, parsed.name + newExt
    options.locals.subPages = getOtherPages f
    template = cc.compile d, options
    fs.writeFile newFile, cc.render template

processFile = (f, done) ->
  parsed = path.parse f

  return done() if parsed.name[0] is '.' or not parsed.ext

  if proc = processors[parsed.ext[1..]]
    proc(f, parsed, done)
  else
    done console.log "Ignoring #{f}"

backLog = process.argv[2..]

doBacklog = ->
  if backLog
    f = backLog.shift()
    processFile f, doBacklog for f in process.argv[2..]
  else
    console.log 'Done!'

doBacklog backLog
