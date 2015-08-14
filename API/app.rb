require 'sinatra'
require 'json'
 
get '/show' do
  article = {
      id: 1,
      title: "today's dialy",
      content: "It's a sunny day."
  }
 
  article.to_json
end
 
post '/edit' do
  body = request.body.read
 
  if body == ''
    status 400
  else
    body.to_json
  end
end