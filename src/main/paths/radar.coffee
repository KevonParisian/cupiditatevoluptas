define [
  './semi-regular-polygon'
  './ops'
], (SemiRegularPolygon, O)->
  rand_int = (max) ->
    Math.floor(Math.random() * max)

  random_colors = ->
    "rgb(#{ rand_int(256) }, #{ rand_int(256) }, #{ rand_int(256) })"

  collect_keys = (objects) ->
    keys = []
    keysets = (Object.keys o for o in objects)
    for object in objects
      for key in Object.keys object
        if keys.indexOf(key) == -1
          keys.push key
    keys

  key_accessor = (keys) ->
    a = {}
    for key in keys
      ((k) -> (a[k] = (o) -> o[k]))(key)
    a

  global_max = (data, accessor) ->
    keys = Object.keys accessor
    maxs = data.map (d) ->
      vals = keys.map (k) -> accessor[k](d)
      O.max(vals)
    O.max(maxs)

  ({data, accessor, center, r, max, rings, colors}) ->
    rings ?= 3
    colors ?= O.random_colors
    accessor ?= key_accessor(collect_keys(data))
    keys = Object.keys accessor
    sides = keys.length
    angle = 2 * Math.PI / sides
    i = -1
    max ?= global_max(data, accessor)

    ring_paths = [1..rings].map (n) ->
      radius = r * n / rings
      SemiRegularPolygon
        center: center
        radii: [0..sides - 1].map (s) -> radius

    polygons = data.map (d) ->
      i += 1

      polygon: SemiRegularPolygon
        center: center
        radii: keys.map (k) -> r * accessor[k](d) / max
      item: d
      color: colors(i)

    curves: polygons
    rings: ring_paths