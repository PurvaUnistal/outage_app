import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinKitDancingSquareWidget.dart';
import 'package:outage_app/Utils/common_widgets/Loader/SpinLoader.dart';
import 'package:outage_app/Utils/common_widgets/Background/background_info_widget.dart';
import 'package:outage_app/Utils/common_widgets/icon_button.dart';
import 'package:outage_app/Utils/common_widgets/message_box_two_button_pop.dart';
import 'package:outage_app/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:outage_app/Utils/common_widgets/res/common_style.dart';
import 'package:outage_app/Utils/common_widgets/res/enums.dart';
import 'package:outage_app/Utils/common_widgets/res/environment_config.dart';
import 'package:outage_app/Utils/common_widgets/text_form_widget.dart';
import 'package:outage_app/features/Manage/ManageAlert/domain/bloc/manage_alert_bloc.dart';
import 'package:outage_app/features/Manage/ManageAlert/domain/bloc/manage_alert_event.dart';
import 'package:outage_app/features/Manage/ManageAlert/domain/bloc/manage_alert_state.dart';
import '../widget/action_items_widget.dart';
import '../widget/tab_item.dart';

class ManageAlertView extends StatefulWidget {
  const ManageAlertView({super.key});

  @override
  State<ManageAlertView> createState() => _ManageAlertViewState();
}

class _ManageAlertViewState extends State<ManageAlertView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    BlocProvider.of<ManageAlertBloc>(
      context,
    ).add(ManageAlertLoadEvent(context: context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.manageAlert, boolLeading: true),
      body: BackgroundInfoWidget(
        child: BlocBuilder<ManageAlertBloc, ManageAlertState>(
          builder: (context, state) {
            if (state is FetchManageAlertDataState) {
              return _itemBuilder(dataState: state);
            } else {
              return const Center(child: SpinLoader());
            }
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder:
              (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to  Manage Incident?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true),
              ),
        )) ??
        false;
  }

  Widget _itemBuilder({required FetchManageAlertDataState dataState}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _searchPriorityController(dataState: dataState),
          CommonStyle.vertical(context: context),
          _tabControllerWidget(dataState: dataState),
        ],
      ),
    );
  }

  Widget _searchPriorityController({
    required FetchManageAlertDataState dataState,
  }) {
    return TextFieldWidget(
      label: AppString.searchPriority,
      hintText: AppString.searchPriority,
      controller: dataState.searchPriorityController,
      keyboardType: TextInputType.name,
      maxLength: 10,
      suffixIcon: IconButtonWidget(
        iconData: Icons.search_rounded,
        onPressed: () {},
      ),
      onChanged: (val) {
        BlocProvider.of<ManageAlertBloc>(
          context,
        ).add(SelectSearchPriorityEvent(searchPriority: val));
      },
    );
  }

  Widget _tabControllerWidget({required FetchManageAlertDataState dataState}) {
    return Flexible(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: EnvironmentConfig.of(
                  context,
                )!.primaryTheme.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  TabItem(
                    title: AppString.newData,
                    count:
                        dataState.listOfViewIncident
                            .where(
                              (taskData) =>
                                  taskData.actionStatus ==
                                  ActionStatus.newAction,
                            )
                            .toList()
                            .length,
                  ),
                  TabItem(
                    title: AppString.inProgress,
                    count:
                        dataState.listOfViewIncident
                            .where(
                              (taskData) =>
                                  taskData.actionStatus ==
                                  ActionStatus.inProgress,
                            )
                            .toList()
                            .length,
                  ),
                  TabItem(
                    title: AppString.completed,
                    count:
                        dataState.listOfViewIncident
                            .where(
                              (taskData) =>
                                  taskData.actionStatus ==
                                  ActionStatus.completed,
                            )
                            .toList()
                            .length,
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: EnvironmentConfig.of(context)!.primaryTheme,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelColor: AppColor.white,
                unselectedLabelColor: AppColor.black,
                onTap: (index) {
                  BlocProvider.of<ManageAlertBloc>(context).add(
                    SelectTabChangedEvent(tabIndex: index, context: context),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                _itemWidget(dataState: dataState),
                _itemWidget(dataState: dataState),
                _itemWidget(dataState: dataState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemWidget({required FetchManageAlertDataState dataState}) {
    return dataState.listOfFilterViewIncident.isNotEmpty
        ? dataState.tabIndexLoader == false
            ? ListView.builder(
              itemCount: dataState.listOfFilterViewIncident.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () async {
                    BlocProvider.of<ManageAlertBloc>(
                      context,
                    ).add(SelectPageSelectDataEvent(index: i));
                  },
                  child: ActionItemsWidget(
                    viewIncidentData: dataState.listOfFilterViewIncident[i],
                  ),
                );
              },
            )
            : SpinKitDancingSquareLoader()
        : Center(child: Text("No records found", style: Styles.labels));
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    BlocProvider.of<ManageAlertBloc>(!context.mounted ? context : context).add(
      ManagePageRefreshDataEvent(context: !context.mounted ? context : context),
    );
  }
}
