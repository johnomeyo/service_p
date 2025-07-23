import 'package:flutter/material.dart';

// --- 1. Data Models ---

/// Represents a single customer review.
class Review {
  final String reviewerName;
  final String reviewText;
  final double rating;
  final String date;
  final String? avatarUrl;

  const Review({
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.date,
    this.avatarUrl,
  });
}

/// Represents the complete profile information for a service provider business.
class BusinessProfile {
  final String name;
  final String logoUrl;
  final String about;
  final String description;
  final String openingTime;
  final String closingTime;
  final String location;
  final double averageRating;
  final int reviewCount;
  final List<String> availableServices;
  final List<Review> customerReviews;

  const BusinessProfile({
    required this.name,
    required this.logoUrl,
    required this.about,
    required this.description,
    required this.openingTime,
    required this.closingTime,
    required this.location,
    required this.averageRating,
    required this.reviewCount,
    required this.availableServices,
    required this.customerReviews,
  });
}

// --- 2. Main Profile Page ---

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Dummy Business Profile Data
  BusinessProfile get _dummyBusinessProfile => const BusinessProfile(
        name: 'Elite Barber & Spa',
        logoUrl: 'https://placehold.co/100x100/0000FF/FFFFFF?text=Logo', // Placeholder logo
        about: 'Your premier destination for top-notch grooming and relaxation services.',
        description:
            '',
        openingTime: '09:00 AM',
        closingTime: '08:00 PM',
        location: '123 Main St, Anytown, CA 90210',
        averageRating: 4.8,
        reviewCount: 12,
        availableServices: [
          'Haircut & Styling',
          'Beard Trim',
          'Hot Towel Shave',
          'Deep Tissue Massage',
          'Facial Treatment',
          'Manicure & Pedicure',
        ],
        customerReviews: [
          Review(
            reviewerName: 'Alice Smith',
            reviewText: 'Fantastic service! My haircut was perfect and the staff were very friendly.',
            rating: 5.0,
            date: '2024-07-20',
            avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
          ),
          Review(
            reviewerName: 'Bob Johnson',
            reviewText: 'Great massage, very relaxing. Will definitely come back.',
            rating: 4.5,
            date: '2024-07-18',
            avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
          ),
          Review(
            reviewerName: 'Charlie Brown',
            reviewText: 'The facial was amazing, my skin feels so refreshed. Highly recommend!',
            rating: 5.0,
            date: '2024-07-15',
            avatarUrl: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150&h=150&fit=crop&crop=face',
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final profile = _dummyBusinessProfile; 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile Pressed!')),
              );
            },
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Header (Logo, Name, Review Summary)
            BusinessHeader(profile: profile),
            const SizedBox(height: 24),

            // About Section
            AboutSection(about: profile.about, description: profile.description),
            const SizedBox(height: 24),

            // Operating Hours
            OperatingHours(
              openingTime: profile.openingTime,
              closingTime: profile.closingTime,
            ),
            const SizedBox(height: 24),

            // Location Info
            LocationInfo(location: profile.location),
            const SizedBox(height: 24),

            // Available Services
            ServiceList(services: profile.availableServices),
            const SizedBox(height: 24),

            // Customer Reviews
            CustomerReviewsSection(reviews: profile.customerReviews),
            const SizedBox(height: 24), // Extra space at the bottom
          ],
        ),
      ),
    );
  }
}

// --- 3. Modular Widgets for Profile Sections ---

class BusinessHeader extends StatelessWidget {
  final BusinessProfile profile;

  const BusinessHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Business Logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              profile.logoUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.store,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 60,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Business Name
        Text(
          profile.name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Review Summary
        ReviewSummary(
          averageRating: profile.averageRating,
          reviewCount: profile.reviewCount,
        ),
      ],
    );
  }
}

class ReviewSummary extends StatelessWidget {
  final double averageRating;
  final int reviewCount;

  const ReviewSummary({
    super.key,
    required this.averageRating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star_rounded, color: Colors.amber[600], size: 24),
        const SizedBox(width: 4),
        Text(
          averageRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($reviewCount Reviews)',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class AboutSection extends StatelessWidget {
  final String about;
  final String description;

  const AboutSection({
    super.key,
    required this.about,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          about,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class OperatingHours extends StatelessWidget {
  final String openingTime;
  final String closingTime;

  const OperatingHours({
    super.key,
    required this.openingTime,
    required this.closingTime,
  });

  @override
  Widget build(BuildContext context) {
    return _buildInfoCard(
      context,
      icon: Icons.access_time,
      title: 'Operating Hours',
      content: '$openingTime - $closingTime',
    );
  }
}

class LocationInfo extends StatelessWidget {
  final String location;

  const LocationInfo({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return _buildInfoCard(
      context,
      icon: Icons.location_on_outlined,
      title: 'Location',
      content: location,
    );
  }
}

// Helper for consistent info cards
Widget _buildInfoCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String content,
}) {
  return Card(
    elevation: 0.5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    color: Theme.of(context).colorScheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ServiceList extends StatelessWidget {
  final List<String> services;

  const ServiceList({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0, 
          runSpacing: 8.0, 
          children: services.map((service) {
            return Chip(
              label: Text(service),
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CustomerReviewsSection extends StatelessWidget {
  final List<Review> reviews;

  const CustomerReviewsSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const SizedBox.shrink(); 
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ReviewCard(review: review),
            );
          },
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: review.avatarUrl != null
                      ? NetworkImage(review.avatarUrl!)
                      : null,
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  child: review.avatarUrl == null
                      ? Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimaryContainer)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        review.date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber[600], size: 18),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.reviewText,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}