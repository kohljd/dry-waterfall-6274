require "rails_helper"

RSpec.describe "Plots Index", type: :feature do
  describe "As a visitor" do
    let!(:garden_1) { Garden.create!(name: "Leaf It", organic: true)}
    let!(:garden_2) { Garden.create!(name: "Garden the Plants from Harm", organic: false)}

    let!(:plot_1) { garden_1.plots.create!(number: 1, size: "small", direction: "north")}
    let!(:plot_2) { garden_1.plots.create!(number: 2, size: "medium", direction: "south")}
    let!(:plot_3) { garden_2.plots.create!(number: 3, size: "large", direction: "east")}
    let!(:plot_4) { garden_2.plots.create!(number: 4, size: "x-large", direction: "west")}

    let!(:plant_1) {Plant.create!(name: "Pumpkin", description: "Halloween fun", days_to_harvest: 130)}
    let!(:plant_2) {Plant.create!(name: "Potato", description: "delicious", days_to_harvest: 35)}
    let!(:plant_3) {Plant.create!(name: "Cabbage", description: "rabbit food", days_to_harvest: 20)}
    let!(:plant_4) {Plant.create!(name: "Carrot", description: "better rabbit food", days_to_harvest: 101)}
    let!(:plant_5) {Plant.create!(name: "Tomato", description: "always taken off my sandwiches", days_to_harvest: 52)}

    let!(:plot_plant_1) {PlotPlant.create!(plot: plot_1, plant: plant_1)}
    let!(:plot_plant_2) {PlotPlant.create!(plot: plot_1, plant: plant_2)}

    let!(:plot_plant_3) {PlotPlant.create!(plot: plot_2, plant: plant_2)}
    let!(:plot_plant_4) {PlotPlant.create!(plot: plot_2, plant: plant_3)}

    let!(:plot_plant_5) {PlotPlant.create!(plot: plot_3, plant: plant_3)}
    let!(:plot_plant_6) {PlotPlant.create!(plot: plot_3, plant: plant_4)}
    let!(:plot_plant_7) {PlotPlant.create!(plot: plot_3, plant: plant_5)}

    let!(:plot_plant_8) {PlotPlant.create!(plot: plot_4, plant: plant_1)}
    let!(:plot_plant_9) {PlotPlant.create!(plot: plot_4, plant: plant_4)}
    let!(:plot_plant_10) {PlotPlant.create!(plot: plot_4, plant: plant_5)}
    
    before do
      visit "/plots"
    end

    it "displays all plot numbers" do
      expect(page).to have_content("Plot #{plot_1.id}")
      expect(page).to have_content("Plot #{plot_2.id}")
      expect(page).to have_content("Plot #{plot_3.id}")
      expect(page).to have_content("Plot #{plot_4.id}")
    end

    it "lists each plot's plants" do
      within "#plot-#{plot_1.id}" do
        expect(page).to have_content("Pumpkin")
        expect(page).to have_content("Potato")
        expect(page).to_not have_content("Cabbage")
        expect(page).to_not have_content("Carrot")
        expect(page).to_not have_content("Tomato")
      end
      
      within "#plot-#{plot_2.id}" do
        expect(page).to have_content("Potato")
        expect(page).to have_content("Cabbage")
        expect(page).to_not have_content("Pumpkin")
        expect(page).to_not have_content("Carrot")
        expect(page).to_not have_content("Tomato")
      end

      within "#plot-#{plot_3.id}" do
        expect(page).to have_content("Cabbage")
        expect(page).to have_content("Carrot")
        expect(page).to have_content("Tomato")
        expect(page).to_not have_content("Pumpkin")
        expect(page).to_not have_content("Potato")
      end

      within "#plot-#{plot_4.id}" do
        expect(page).to have_content("Pumpkin")
        expect(page).to have_content("Carrot")
        expect(page).to have_content("Tomato")
        expect(page).to_not have_content("Potato")
        expect(page).to_not have_content("Cabbage")
      end
    end

    describe "can remove plant from a plot" do
      it "delete button next to each plant" do
        within "#plot-#{plot_1.id}" do
          expect(page).to have_content("Delete", count: 2)
        end

        within "#plot-#{plot_4.id}" do
         expect(page).to have_content("Delete", count: 3)
        end
      end

      it "clicking 'delete' reloads the page without the deleted item" do
        within "#plot-#{plot_1.id}" do
          click_on "Delete", match: :first

          expect(current_path).to eq("/plots")
          expect(page).to have_content("Potato")
          expect(page).to_not have_content("Pumpkin")
        end

        within "#plot-#{plot_4.id}" do
          expect(page).to have_content("Pumpkin")
        end
      end
    end
  end
end