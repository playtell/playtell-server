class DailiesController < ApplicationController
  # GET /dailies
  # GET /dailies.xml
  def index
    @daily = Daily.find_or_initialize_by_d(Date.today)  
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dailies }
    end
  end

  # GET /dailies/1
  # GET /dailies/1.xml
  def show
    @daily = Daily.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @daily }
    end
  end

  # GET /dailies/new
  # GET /dailies/new.xml
  def new
    @daily = Daily.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @daily }
    end
  end

  # GET /dailies/1/edit
  def edit
    @daily = Daily.find(params[:id])
  end

  # POST /dailies
  # POST /dailies.xml
  def create
    @daily = Daily.new(params[:daily])

    respond_to do |format|
      if @daily.save
        format.html { redirect_to(dailies_url, :notice => 'Daily was successfully created.') }
        format.js
        format.xml  { render :xml => @daily, :status => :created, :location => @daily }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @daily.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dailies/1
  # PUT /dailies/1.xml
  def update
    @daily = Daily.find(params[:id])

    respond_to do |format|
      if @daily.update_attributes(params[:daily])
        format.html { redirect_to(@daily, :notice => 'Daily was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @daily.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dailies/1
  # DELETE /dailies/1.xml
  def destroy
    @oldDaily = Daily.find(params[:id])
    @oldDaily.destroy
    @daily = Daily.new 
    
    respond_to do |format|
      format.html { redirect_to(dailies_url) }
      format.js
      format.xml  { head :ok }
    end
  end
end
