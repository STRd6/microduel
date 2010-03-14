class GamesController < ResourceController::Base
  actions :all, :except => [:edit, :update, :destroy]

  before_filter :require_user, :except => [:show, :index]

  before_filter :ensure_priority, :except => [:new, :join, :create, :show, :index, :start]
  before_filter :ensure_active, :except => [:new, :join, :create, :show, :index, :start]
  before_filter :ensure_attack_phase, :only => :attack
  before_filter :ensure_pre_attack_phase, :only => :activate

  helper_method :is_priority_player?

  def start
    game.begin_game
    game.save!

    render_to_game do |page|
      page.call "$('.gameState').html", game.state
    end
  end

  def join
    game.join(current_user)
    game.save!

    smart_redirect(game)
  end

  def pass_priority
    game.pass_priority
    game.save!

    render_to_game do |page|
      page.call "$('.gameState').html", game.state
      
      #TODO: Update players info only as needed
      # page.call :updateElements, object.players
    end
  end

  def activate
    game_card_index = params[:game_card_index].to_i
    ability_index = params[:ability_index].to_i

    if game_card_index >= 0 && ability_index >= 0
      card = priority_player.game_cards.all[game_card_index]

      temp_bonus = card.do_activation(ability_index)

      priority_player.add_temp_bonus(temp_bonus)
      priority_player.save!
    end
  end

  def allocate
    if game.allocate_stars_phase? || game.setup?
      requesting_player.allocate_stars(allocation)
    elsif game.allocate_time_phase?
      requesting_player.allocate_time(allocation)
    end

    render :nothing => true
  end

  def attack
    attack_declarations.each do |game_card_index, attack_index, player_id|
      target_player = game.players.find(player_id)

      card = active_player.game_cards.all[game_card_index]

      damage = card.do_attack(attack_index, active_player.bonuses)

      target_player.receive_damage(damage)
    end

    render_to_game do |page|
      page.call :updateElements, game.players
    end
  end

  create.before do
    game.join(current_user)
  end

  private
  def game
    object
  end
  helper_method :game

  def active_player
    game.active_player
  end

  def priority_player
    game.priority_player
  end

  def requesting_player
    game.players.find_by_user_id(current_user.id) if current_user
  end

  def ensure_main_phase
    unless game.first_main_phase? || game.second_main_phase?
      smart_ensure("Not in main phase!")
    end
  end

  def ensure_attack_phase
    unless game.attack_phase?
      smart_ensure("Not in attack phase!")
    end
  end

  def ensure_pre_attack_phase
    unless game.pre_attack_phase?
      smart_ensure("Not in pre attack phase!")
    end
  end

  def ensure_priority
    unless is_priority_player?
      smart_ensure("You do not have priority!")
    end
  end

  def ensure_active
    unless is_active_player?
      smart_ensure("You are not the active player!")
    end
  end

  def is_priority_player?
    priority_player == requesting_player
  end

  def is_active_player?
    active_player == requesting_player
  end

  def smart_ensure(msg)
    if request.xhr?
      render :update do |page|
        page.call "alert", msg
      end
    else
      flash[:error] = msg
      redirect_to game
    end
  end

  def render_to_game(&block)
    # render({:juggernaut => {:type => :send_to_channels, :channels => [object.channel]}}, {}, &block)

    if request.xhr?
      render :nothing => true
    else
      redirect_to game
    end
  end

  def allocation
    params[:allocation].map do |key, value|
      [key.to_i, value.to_i]
    end
  end

  def attack_declarations
    params[:attack_declarations].map do |index, player_id|
      card_attack_index = index.split(",").map(&:to_i)
      card_index = card_attack_index[0]
      attack_index = card_attack_index[1]

      [card_index, attack_index, player_id.to_i]
    end
  end
end
