class MixtransaccionestsController < ApplicationController
  before_action :set_mixtransaccionest, only: [:show, :edit, :update, :destroy]

  # GET /mixtransaccionests
  # GET /mixtransaccionests.json
  def index
    @mixtransaccionests = Mixtransaccionest.all
  end

  # GET /mixtransaccionests/1
  # GET /mixtransaccionests/1.json
  def show
  end

  # GET /mixtransaccionests/new
  def new
    @mixtransaccionest = Mixtransaccionest.new
  end

  # GET /mixtransaccionests/1/edit
  def edit
  end

  # POST /mixtransaccionests
  # POST /mixtransaccionests.json
  def create
    @mixtransaccionest = Mixtransaccionest.new(mixtransaccionest_params)

    respond_to do |format|
      if @mixtransaccionest.save
        format.html { redirect_to @mixtransaccionest, notice: 'Mixtransaccionest was successfully created.' }
        format.json { render :show, status: :created, location: @mixtransaccionest }
      else
        format.html { render :new }
        format.json { render json: @mixtransaccionest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mixtransaccionests/1
  # PATCH/PUT /mixtransaccionests/1.json
  def update
    respond_to do |format|
      if @mixtransaccionest.update(mixtransaccionest_params)
        format.html { redirect_to @mixtransaccionest, notice: 'Mixtransaccionest was successfully updated.' }
        format.json { render :show, status: :ok, location: @mixtransaccionest }
      else
        format.html { render :edit }
        format.json { render json: @mixtransaccionest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mixtransaccionests/1
  # DELETE /mixtransaccionests/1.json
  def destroy
    @mixtransaccionest.destroy
    respond_to do |format|
      format.html { redirect_to mixtransaccionests_url, notice: 'Mixtransaccionest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mixtransaccionest
      @mixtransaccionest = Mixtransaccionest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mixtransaccionest_params
      params.require(:mixtransaccionest).permit(:maquinat_id, :tipotransaccion, :cantidad, :comando, :status, :descripcion)
    end
end
