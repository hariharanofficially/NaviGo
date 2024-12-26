import 'package:EquineApp/feature/subscripition/plans/payment_details/payment/view/payment_view.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/view/single_stable_view.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/view/subscription_plan_view.dart';
import 'package:go_router/go_router.dart';
import '../../../feature/all_api/Breed/breed.dart';
import '../../../feature/all_api/Breed/breed_list.dart';
import '../../../feature/all_api/Breeder/breeder.dart';
import '../../../feature/all_api/Division/division.dart';
import '../../../feature/all_api/Division/list_division.dart';
import '../../../feature/subscripition/add_forms/Event/event.dart';
import '../../../feature/all_api/Event_State/event_state.dart';
import '../../../feature/all_api/Event_State/event_state_list.dart';
import '../../../feature/all_api/Event_Type/event_type.dart';
import '../../../feature/all_api/Event_Type/eventtypelist.dart';
import '../../../feature/all_api/Event_group/event_group.dart';
import '../../../feature/all_api/Event_group/event_group_list.dart';
import '../../../feature/subscripition/add_forms/Event/event_list.dart';
import '../../../feature/subscripition/add_forms/Horse/view/add_horse.dart';
import '../../../feature/subscripition/add_forms/Horse/horse_data_table.dart';
import '../../../feature/all_api/Horse_Color/horse_color.dart';
import '../../../feature/all_api/Horse_Color/horse_color_list.dart';
import '../../../feature/all_api/Horse_Gender/horse_gender.dart';
import '../../../feature/all_api/Horse_Gender/horse_gender_list.dart';
import '../../../feature/all_api/Participant/participant.dart';
import '../../../feature/all_api/Participant/participant_list.dart';
import '../../../feature/subscripition/add_forms/Rider/rider.dart';
import '../../../feature/subscripition/add_forms/Rider/riderlist.dart';
import '../../../feature/subscripition/add_forms/Stable/view/add_stable.dart';
import '../../../feature/subscripition/add_forms/Stable/list_stable.dart';
import '../../../feature/all_api/Tracker_device/tracker_device.dart';
import '../../../feature/all_api/Tracker_device/tracker_device_list.dart';
import '../../../feature/all_api/Tracker_feed/tracker_feed.dart';
import '../../../feature/all_api/Tracker_feed/tracker_feed_list.dart';
import '../../../feature/all_api/button_api.dart';
import '../../../data/models/participant_model.dart';
import '../../../feature/dashboard/dashboard_screen.dart';
import '../../../feature/home/home_screen.dart';
import '../../../feature/init/init_screen.dart';
import '../../../feature/live_tracking/live_tracking_screen.dart';
import '../../../feature/participants/participants_screen.dart';
import '../../../feature/signin/singin_screen.dart';
import '../../../feature/signup/singup_screen.dart';
import '../../../feature/static_tracking/static_tracking_screen.dart';
import '../../../feature/subscripition/add_forms/Owner/owner_list.dart';
import '../../../feature/subscripition/add_forms/Owner/view/owner.dart';
import '../../../feature/tracker/tracker_screen.dart';
import '../../../feature/tracker_steps/tracker_steps_screen.dart';
// import '../../../subscription_plan/My_Plan/Event_Oraganizer/view/event_organizer_view.dart';
// import '../../../subscription_plan/My_Plan/Multi_Stable/view/multi_stableview.dart';
import '../../../feature/subscripition/home_dashboard/Event_Oraganizer/view/event_organizer_view.dart';
import '../../../feature/subscripition/home_dashboard/Multi_Stable/view/multi_stableview.dart';
import 'route_path.dart';

final router = GoRouter(
  initialLocation: RoutePath.init,
  routes: [
    GoRoute(
      path: RoutePath.init,
      name: RoutePath.init,
      builder: (context, state) => const InitScreen(),
    ),
    GoRoute(
      path: RoutePath.signin,
      name: RoutePath.signin,
      builder: (context, state) => const SigninScreen(),
    ),
    GoRoute(
      path: RoutePath.signup,
      name: RoutePath.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: RoutePath.dashboard,
      name: RoutePath.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: RoutePath.tracker,
      name: RoutePath.tracker,
      builder: (context, state) => const TrackerScreen(),
    ),
    GoRoute(
      path: "${RoutePath.participants}/:id",
      name: RoutePath.participants,
      builder: (context, state) => ParticipantsScreen(
        id: state.pathParameters["id"] ?? "",
      ),
    ),
    GoRoute(
        path: RoutePath.staticTracking,
        name: RoutePath.staticTracking,
        builder: (context, state) {
          ParticipantModel participant = state.extra as ParticipantModel;
          return StaticTrackingScreen(participant: participant);
        }),
    GoRoute(
        path: RoutePath.liveTracking,
        name: RoutePath.liveTracking,
        builder: (context, state) {
          ParticipantModel participant = state.extra as ParticipantModel;
          return LiveTrackingScreen(participant: participant);
        }),
    GoRoute(
      path: RoutePath.trackingstates,
      name: RoutePath.trackingstates,
      builder: (context, state) => const TrackerStepsScreen(),
    ),
    GoRoute(
      path: RoutePath.home,
      name: RoutePath.home,
      builder: (context, state) => const HomeScreen(),
      routes: [],
    ),
    GoRoute(
      path: RoutePath.payment,
      name: RoutePath.payment,
      builder: (context, state) => PaymentPage(),
    ),
    GoRoute(
      path: RoutePath.people,
      name: RoutePath.people,
      builder: (context, state) => AddStableScreen(),
    ),
    GoRoute(
      path: RoutePath.horse,
      name: RoutePath.horse,
      builder: (context, state) => AddHorseScreen(),
    ),
    GoRoute(
      path: RoutePath.stable,
      name: RoutePath.stable,
      builder: (context, state) => AddStableScreen(),
    ),
    GoRoute(
      path: RoutePath.datatable,
      name: RoutePath.datatable,
      builder: (context, state) => HorseListPage(),
    ),
    GoRoute(
      path: RoutePath.plan,
      name: RoutePath.plan,
      builder: (context, state) => subs_plan(),
    ),
    GoRoute(
      path: RoutePath.stablelist,
      name: RoutePath.stablelist,
      builder: (context, state) => StableListPage(),
    ),
    GoRoute(
      path: RoutePath.postapi,
      name: RoutePath.postapi,
      builder: (context, state) => button_api(),
    ),
    GoRoute(
      path: RoutePath.division,
      name: RoutePath.division,
      builder: (context, state) => const DivisionForm(),
    ),
    GoRoute(
      path: RoutePath.divisionlist,
      name: RoutePath.divisionlist,
      builder: (context, state) =>  DivisionListPage(),
    ),
    GoRoute(
      path: RoutePath.eventgroup,
      name: RoutePath.eventgroup,
      builder: (context, state) =>  EventGroupForm(),
    ),
    GoRoute(
      path: RoutePath.eventgrouplist,
      name: RoutePath.eventgrouplist,
      builder: (context, state) =>  EventGroupListPage(),
    ),
    GoRoute(
      path: RoutePath.eventstate,
      name: RoutePath.eventstate,
      builder: (context, state) =>  EventStateForm(),
    ),
    GoRoute(
      path: RoutePath.eventstatelist,
      name: RoutePath.eventstatelist,
      builder: (context, state) =>  EventStateListPage(),
    ),
    GoRoute(
      path: RoutePath.eventtype,
      name: RoutePath.eventtype,
      builder: (context, state) =>  EventTypeForm(),
    ),
    GoRoute(
      path: RoutePath.eventtypelist,
      name: RoutePath.eventtypelist,
      builder: (context, state) =>  EventTypeListPage(),
    ),
    GoRoute(
      path: RoutePath.event,
      name: RoutePath.event,
      builder: (context, state) =>  EventForm(),
    ),
    GoRoute(
      path: RoutePath.eventlist,
      name: RoutePath.eventlist,
      builder: (context, state) =>  EventListPage(),
    ),
    GoRoute(
      path: RoutePath.breed,
      name: RoutePath.breed,
      builder: (context, state) =>  BreedForm(),
    ),
    GoRoute(
      path: RoutePath.breedlist,
      name: RoutePath.breedlist,
      builder: (context, state) =>  BreedListPage(),
    ),
    GoRoute(
      path: RoutePath.breeder,
      name: RoutePath.breeder,
      builder: (context, state) =>  BreederForm(),
    ),
    GoRoute(
      path: RoutePath.breederlist,
      name: RoutePath.breederlist,
      builder: (context, state) =>  BreedListPage(),
    ),
    GoRoute(
      path: RoutePath.horsecolor,
      name: RoutePath.horsecolor,
      builder: (context, state) => HorseColorForm(),
    ),
    GoRoute(
      path: RoutePath.horsecolorlist,
      name: RoutePath.horsecolorlist,
      builder: (context, state) => HorseColorListPage(),
    ),
    GoRoute(
      path: RoutePath.horsegender,
      name: RoutePath.horsegender,
      builder: (context, state) => HorseGenderForm(),
    ),
    GoRoute(
      path: RoutePath.horsegenderlist,
      name: RoutePath.horsegenderlist,
      builder: (context, state) => HorseGenderListPage(),
    ),
    GoRoute(
      path: RoutePath.owner,
      name: RoutePath.owner,
      builder: (context, state) => AddOwnerForm(),
    ),
    GoRoute(
      path: RoutePath.ownerlist,
      name: RoutePath.ownerlist,
      builder: (context, state) => OwnerListPage(),
    ),
    GoRoute(
      path: RoutePath.rider,
      name: RoutePath.rider,
      builder: (context, state) => RiderForm(),
    ),
    GoRoute(
      path: RoutePath.riderlist,
      name: RoutePath.riderlist,
      builder: (context, state) => RiderListPage(),
    ),
    GoRoute(
      path: RoutePath.trackerdevice,
      name: RoutePath.trackerdevice,
      builder: (context, state) => TrackerDeviceForm(),
    ),
    GoRoute(
      path: RoutePath.trackerdevicelist,
      name: RoutePath.trackerdevicelist,
      builder: (context, state) => TrackerDeviceListPage(),
    ),
    GoRoute(
      path: RoutePath.participant,
      name: RoutePath.participant,
      builder: (context, state) => ParticipantForm(),
    ),
    GoRoute(
      path: RoutePath.participantlist,
      name: RoutePath.participantlist,
      builder: (context, state) => ParticipantListPage(),
    ),
    GoRoute(
      path: RoutePath.trackerfeed,
      name: RoutePath.trackerfeed,
      builder: (context, state) => TrackerFeedForm(),
    ),
    GoRoute(
      path: RoutePath.trackerfeetlist,
      name: RoutePath.trackerfeetlist,
      builder: (context, state) => TrackerFeedListPage(),
    ),
    GoRoute(
    path: RoutePath.singlestabledashboard,
    name: RoutePath.singlestabledashboard,
    builder: (context, state) => SingleStableDashboard(),
    ),
    GoRoute(
    path: RoutePath.multistabledashboard,
    name: RoutePath.multistabledashboard,
    builder: (context, state) => MultiStableDashboard(),
    ),
    GoRoute(
    path: RoutePath.eventorganizerdashboard,
    name: RoutePath.eventorganizerdashboard,
    builder: (context, state) => EventsOrganizerDashboard(),
    ),
  ],
);
