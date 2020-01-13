import './main.css';
import { Elm } from './Main.elm';

mapboxgl.accessToken = process.env.ELM_APP_MAPBOX_TOKEN;

var app = Elm.Main.init({
    node: document.getElementById('root')
});

app.ports.sendGeoJsonToClient.subscribe(function(data) {
    const map = new mapboxgl.Map({
        container: 'map',
        trackResize: false,
        style: 'mapbox://styles/mapbox/light-v10',
        center: [-75.1652, 39.9826],
        zoom: 11
    });

    map.on('load', function () {
        map.addLayer({
            id: 'points',
            type: 'symbol',
            source: {
                type: 'geojson',
                data
            },
            layout: {
                'icon-image': 'dot-11',
                'icon-size': 3,
                'text-field': ['get', 'SCHOOL_NAME'],
                'text-font': ['Open Sans Semibold'],
                'text-offset': [0, 0.6],
                'text-anchor': 'top'
            }
        });
    });
});
