package com.gestion.controller.dashboard;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.gestion.service.dashboard.DashboardService;

import java.util.Map;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {
    private final DashboardService dashboardService;

    @Autowired
    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("")
    public ModelAndView home() {
        ModelAndView mv = new ModelAndView("dashboard");
        Map<String, Long> kpis = dashboardService.getKpis();
        mv.addObject("kpis", kpis);
        mv.addObject("roleLabels", dashboardService.getRoleLabels());
        mv.addObject("roleCounts", dashboardService.getRoleCounts());
        mv.addObject("monthLabels", dashboardService.getMonthLabels());
        mv.addObject("monthCounts", dashboardService.getMonthCounts());
        return mv;
    }
}
