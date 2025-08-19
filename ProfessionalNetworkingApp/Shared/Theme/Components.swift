// Components.swift
// Common UI components
/*
Overview
- Small, reusable UI pieces built on top of AppTheme (cards, badges, loading, empty states).

When to use
- ThemedCard: wrap content on a surface (default/subtle/elevated/bordered).
- StatusBadge: show small status labels (success/alert/warning/info/neutral).
- LoadingButton: trigger async actions with a built-in spinner.
- EmptyStateView: friendly placeholder for empty/error views.
- ThemedLoadingView: full-screen loading state matching the theme.

Quick examples
  ThemedCard(style: .elevated) {
    Text("Profile").styled(.headline)
  }

  HStack { StatusBadge(.success, "Active"); StatusBadge(.warning, "Pending") }

  LoadingButton("Save") {
    await viewModel.save()
  }
  .buttonStyle(PrimaryButtonStyle())

  EmptyStateView(icon: "tray",
                 title: "No Items",
                 message: "Try adding a new item",
                 actionTitle: "Add",
                 action: { showingAdd = true })

  ThemedLoadingView(message: "Syncing...")
*/











