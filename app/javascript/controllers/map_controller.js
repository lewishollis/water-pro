import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {apiKey: String, markers: Array}

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
    container: this.element,
    style: 'mapbox://styles/mapbox/streets-v12',
    });
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker, index) => {
      const popup = new mapboxgl.Popup().setHTML(
        `<a href='${marker.popupLink}'>${marker.popupContent}</a>`
      );
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach((marker) => {
      bounds.extend([ marker.lng, marker.lat ])
    })
    this.map.fitBounds(bounds, {})
  }
}
