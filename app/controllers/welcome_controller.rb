require 'beeu'
class WelcomeController < ApplicationController
  include BeeU

  before_filter :assign_user
  before_filter :assign_admin_status
  
  def index
    @comments = Comment.all({}, :limit => 50, :iorder => :created_at)
  end

  def comment
    comment_body = params[:comment][:body].strip
    if comment_body =~ /^(e|rb):(.+)$/
      begin 
        comment_body = eval($2).to_s
        if 100 < comment_body.size
          comment_body = nil
          flash[:notice] = @user.nickname
        end
      rescue Exception
        comment_body = $!.message 
      end
    end
    Comment.create(:nickname => @user.nickname, :body => comment_body, :created_at => Time.now) unless comment_body.blank?
    redirect_to :action => 'index'
  end
end

