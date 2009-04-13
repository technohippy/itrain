require 'beeu'
class WelcomeController < ApplicationController
  include BeeU
  import javax.script.ScriptEngineManager
  import javax.script.ScriptEngine

  before_filter :assign_user
  before_filter :assign_admin_status
  
  def index
    @comments = Comment.all({}, :limit => 50, :iorder => :created_at)
  end

  def comment
    comment_body = params[:comment][:body].strip
    comment_body =
      case comment_body
      when /^(e|rb):(.+)$/
        begin 
          eval($2).to_s
        rescue Exception
          $!.message 
        end
      when /^j:(.+)$/
        begin
          ScriptEngineManager.new.getEngineByName('javascript').eval($1).to_s
        rescue Exception
          $!.message
        end
      else
        comment_body
      end
    Comment.create(:nickname => @user.nickname, :body => comment_body, :created_at => Time.now)
    redirect_to :action => 'index'
  end
end

