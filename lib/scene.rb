# frozen_string_literal: true

class Scene
  attr_reader :name

  def initialize(scene_manager)
    @scene_manager = scene_manager
    @elements = []
  end

  # Called when scene becomes active
  def enter(**_params)
    raise NotImplementedError, "#{self.class} must implement #enter"
  end

  # Called when scene is deactivated
  def exit
    remove_all_elements
  end

  # Called every frame
  def update
    # Override in subclasses if needed
  end

  # Called on mouse down event
  def handle_click(_x, _y)
    raise NotImplementedError, "#{self.class} must implement #handle_click"
  end

  protected

  def add_element(element)
    @elements << element
  end

  def remove_all_elements
    @elements.each do |element|
      element.remove if element.respond_to?(:remove)
    end
    @elements.clear
  end

  def change_scene(scene_name, **params)
    @scene_manager.change_scene(scene_name, **params)
  end
end
