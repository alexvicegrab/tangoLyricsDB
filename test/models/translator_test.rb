require 'test_helper'

class TranslatorTest < ActiveSupport::TestCase
  setup do
    @translator = Translator.new
    @translator.name = " viOlEta aZul "
    @translator.site_name = " aZul oScuro CASI negro "
    @translator.site_link = " http://getbootstrap.com "
  end
  
  test "should not save translator without a name" do
    @translator.name = nil
    assert_not @translator.save
  end
  test "should not save translator without a site_name" do
    @translator.site_name = nil
    assert_not @translator.save
  end
  test "should not save translator without a site_link" do
    @translator.site_link = nil
    assert_not @translator.save
  end
  
  test "should not save translator with short name" do
    @translator.name = "Bob"
    assert_not @translator.save
  end
  test "should not save translator with short site_name" do
    @translator.site_name = "BA"
    assert_not @translator.save
  end
  test "should not save translator with short site_link" do
    @translator.site_link = " http://tiny.uk "
    assert_not @translator.save
  end
  
  test "should not save translator with identical name & site_name combination" do
    @translator.name = " penelope rojas "
    @translator.site_name = " tango rojo "
    assert_not @translator.save
  end
  test "should not save translator with identical site_link" do
    @translator.site_link = " http://www.google.com/ "
    assert_not @translator.save
  end
  test "should not change link capitalisation" do
    @translator.site_link = " http://www.yahOO.com/ "
    @translator.save!
    assert_not_equal @translator.site_link, "http://www.yahoo.com/"
  end
  
  test "should normalise translator name, site_name, site_link" do
    @translator.save!
    assert_equal @translator.name, "Violeta Azul"
    assert_equal @translator.site_name, "Azul Oscuro Casi Negro"
    assert_equal @translator.site_link, "http://getbootstrap.com"
  end
end
