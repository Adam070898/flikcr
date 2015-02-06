enable :sessions

get '/' do
  if session[:user] == nil
    session.clear
    session[:login] = "<p>You are not logged in, <a href='/login'>Log in</a></p>"
  end
  erb :index
end

get '/users/:user_id/albums' do # Displays albums belonging to a user
  @user = User.where(id: params[:user_id]).first
  erb :user
end

get '/albums/:album_id' do # Displays an album
  @counter = 0
  @album = Album.where(id: params[:album_id]).first
  @owner = User.where(id: @album.user_id).first
  erb :album
end

get '/albums/:album_id/:photo_id' do # Displays a photo
  @photo = Photo.where(id: params[:photo_id]).first
  @album = Album.where(id: @photo.album_id).first
  @owner = User.where(id: @album.user_id).first
  erb :photo
end

get '/login' do
  erb :login
end

get '/upload' do
  @user = User.where(id: session[:user]).first
  erb :upload
end

post '/upload' do
  if session[:user] == nil
    @error = " You must be logged in to upload an image"
    erb :login
  else
    puts params
    Photo.create( file: params[:image], album_id: params[:album_id], title: params[:title], album_id: params[:album] )
    erb :index
  end
end

post '/login' do
  login = User.where(name: params[:user], pass: params[:pass])
  test = login.first
  if login == []
    @error = " Invalid username/password"
    erb :login
  else
    session[:login] =
    "<p>Welcome #{test.name}, <a href='/logout'>Log Out</a>
    , <a href='users/#{test.id}/albums'>Your Albums</a>
    , <a href='/upload'>Upload Image</a>
    , <a href='/newalbum'>Create New Album</a>
    </p>"
    session[:user] = test.id

    erb :index
  end
end

get '/newalbum' do
  erb :newalbum
end

post '/newalbum' do
  Album.create(user_id: session[:user], title: params[:title])
  erb :index
end

get '/logout' do
  session.clear
  session[:login] = "<p>You are not logged in, <a href='/login'>Log in</a></p>"
  erb :index
end

get '/register' do
  @error = ""
  erb :register
end

post '/register' do
  if User.where(name: params[:user]) == []
    puts "\n New user" * 6
    user = User.create(name: params[:user], pass: params[:pass])
    Album.create(title: "#{user.name}'s Photos", user_id: user.id)
    @error = " Account successfully created!"
    erb :login
  else
    @error = " Username taken"
    erb :register
  end
end





