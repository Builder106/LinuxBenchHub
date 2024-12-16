# app/controllers/pwa_controller.rb
class PwaController < ApplicationController
   def manifest
     render json: {
       name: "Linux Bench Hub",
       short_name: "LinuxBenchHub",
       start_url: "/",
       display: "standalone",
       background_color: "#ffffff",
       theme_color: "#000000",
       icons: [
         {
           src: "/icon.png",
           sizes: "192x192",
           type: "image/png"
         },
         {
           src: "/icon.svg",
           sizes: "512x512",
           type: "image/svg+xml"
         }
       ]
     }
   end
 
   def service_worker
     # Add your service worker code here
   end
 end