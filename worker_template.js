// Cloudflare Worker for Grafana BigData 41211036
// Hotel Big Data Analytics & Visualization Platform

const ANALYTICS_DATA = __DATA_JSON_PLACEHOLDER__;
const HTML_CONTENT = __HTML_RAW_PLACEHOLDER__;

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    const corsHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, HEAD, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
    };

    if (request.method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders });
    }

    // Health Check
    if (path === "/api/health") {
      return new Response(JSON.stringify({
        status: "ok",
        platform: "Grafana BigData 41211036",
        version: "2.1.0",
        totalHotels: ANALYTICS_DATA.hotels.length,
        totalRecords: ANALYTICS_DATA.meta.totalRecords,
        timestamp: new Date().toISOString()
      }), {
        headers: { "Content-Type": "application/json; charset=utf-8", ...corsHeaders }
      });
    }

    // Full Analytics Dataset
    if (path === "/api/data") {
      return new Response(JSON.stringify(ANALYTICS_DATA), {
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Cache-Control": "public, max-age=3600",
          ...corsHeaders
        }
      });
    }

    // Hotels Filter Endpoint
    if (path === "/api/hotels") {
      const country = url.searchParams.get("country");
      const brand = url.searchParams.get("brand");
      let list = ANALYTICS_DATA.hotels;
      if (country) list = list.filter(h => h.country === country);
      if (brand) list = list.filter(h => h.brandGroup.includes(brand));
      return new Response(JSON.stringify(list), {
        headers: { "Content-Type": "application/json; charset=utf-8", ...corsHeaders }
      });
    }

    // Brands
    if (path === "/api/brands") {
      return new Response(JSON.stringify(ANALYTICS_DATA.brands), {
        headers: { "Content-Type": "application/json; charset=utf-8", ...corsHeaders }
      });
    }

    // Countries
    if (path === "/api/countries") {
      return new Response(JSON.stringify(ANALYTICS_DATA.countries), {
        headers: { "Content-Type": "application/json; charset=utf-8", ...corsHeaders }
      });
    }

    // Correlation
    if (path === "/api/correlation") {
      return new Response(JSON.stringify(ANALYTICS_DATA.brandCountryMatrix), {
        headers: { "Content-Type": "application/json; charset=utf-8", ...corsHeaders }
      });
    }

    // Daily Trends
    if (path === "/api/trends") {
      return new Response(JSON.stringify(ANALYTICS_DATA.dailyTrends), {
        headers: { "Content-Type": "application/json; charset=utf-8", ...corsHeaders }
      });
    }

    // Root HTML page
    return new Response(HTML_CONTENT, {
      headers: {
        "Content-Type": "text/html; charset=utf-8",
        "Cache-Control": "public, max-age=1800"
      }
    });
  }
};
