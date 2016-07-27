{View} = require 'space-pen'
JsonTask = require './atom-mock-jsonTask'
jsonTree = require './json-tree'
$ = jQuery = require 'jquery'

module.exports =
class JsontreeView extends View

  jsonTree: null
  jsonpFixtureWithComment =
     """
     /**/ some.func.name({
        "about": "The Coca-Cola Facebook Page is a collection of your stories showing how people from around the world have helped make Coke into what it is today.",
        "category": "Food/beverages",
        "checkins": 146,
        "description": "Created in 1886 in Atlanta, Georgia, by Dr. John S. Pemberton, Coca-Cola was first offered as a fountain beverage at Jacob's Pharmacy by mixing Coca-Cola syrup with carbonated water. \\n\\nCoca-Cola was patented in 1887, registered as a trademark in 1893 and by 1895 it was being sold in every state and territory in the United States. In 1899, The Coca-Cola Company began franchised bottling operations in the United States. \\n\\nCoca-Cola might owe its origins to the United States, but its popularity has made it truly universal. Today, you can find Coca-Cola in virtually every part of the world.\\n\\nCoca-Cola Page House Rules: http://CokeURL.com/q28a",
        "founded": "1886",
        "is_published": true,
        "talking_about_count": 851563,
        "username": "coca-cola",
        "website": "http://www.coca-cola.com",
        "were_here_count": 0,
        "id": "40796308305",
        "name": "Coca-Cola",
        "link": "http://www.facebook.com/coca-cola",
        "likes": 79142416,
        "cover": {
           "cover_id": "10152973789558306",
           "source": "http://sphotos-f.ak.fbcdn.net/hphotos-ak-prn1/t1/s720x720/1604837_10152973789558306_1796980423_n.jpg",
           "offset_y": 0,
           "offset_x": 50
        }
     });
     """
  htmlval:null

  initialize: ->
    @jsonTask = new JsonTask()



  #// $('#result').text(html).prepend(html + '<br>');
  #$jsonTree = $(html);
  #$('#result').html($jsonTree);



  getTitle: ->
    return "Oreo-Json-Tree"

  viewJsonTree:(jsonContext)  ->
    jsonTree jsonContext,
      onParsed: ->
        console.log 'PARSED', arguments
        return
      onFormatted: (err, html) ->
        console.log 'FORMATTED'
        document.getElementById("jsontreeDiv").innerHTML = html
        #document.getElementsByClassName("jt_collapser").addEventListener 'click', (event) ->
        list = document.getElementsByClassName("jt_collapser")
        for  value in list
          value.addEventListener 'click', (event) ->
            this.parentNode.classList.toggle('jt_collapsed')

        return
    return

  @content: ->
    @div =>
      @script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js'
      @div "Type your answer:"
      @div id:"jsontreeDiv",class:'jsontreeDiv',"tree在这里"
      @div class:"bottomDiv", =>
        @label outlet:"spacecraft",'一定要输入正确的JSON内容哦！'
