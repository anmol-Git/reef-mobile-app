import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:reef_mobile_app/model/account/ReefAccount.dart';
import 'package:reef_mobile_app/model/feedback-data-model/FeedbackDataModel.dart';

import '../../utils/styles.dart';
import '../account_box.dart';
import '../modals/account_modals.dart';

class AccountsList extends StatefulWidget {
  final List<FeedbackDataModel<ReefAccount>> accounts;
  final void Function(String) selectAddress;
  final String? selectedAddress;
  const AccountsList(this.accounts, this.selectedAddress, this.selectAddress,
      {Key? key})
      : super(key: key);

  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  @override
  void initState() {
    super.initState();
    setSelectedAddressInStart();
  }

  void setSelectedAddressInStart() {
    for (int i = 0; i < widget.accounts.length; i++) {
      FeedbackDataModel<ReefAccount> curr = widget.accounts[i];
      String currentAddress = curr.data.address;
      if (currentAddress.compareTo(widget.selectAddress.toString()) == 0) {
        widget.accounts.removeAt(i);
        widget.accounts.insert(0, curr);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: widget.accounts.isEmpty
          ? [
              DottedBorder(
                dashPattern: const [4, 2],
                color: Styles.textLightColor,
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Click on ",
                            style: TextStyle(color: Styles.textLightColor),
                          ),
                          const Gap(2),
                          MaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              showCreateAccountModal(context);
                            },
                            color: Styles.textLightColor,
                            minWidth: 0,
                            height: 0,
                            padding: const EdgeInsets.all(2),
                            shape: const CircleBorder(),
                            elevation: 0,
                            child: const Icon(
                              Icons.add,
                              color: Styles.primaryBackgroundColor,
                              size: 15,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            " to create a new account",
                            style: TextStyle(color: Styles.textLightColor),
                          ),
                        ],
                      )),
                ),
              )
            ]
          : [toAccountBoxList(widget.accounts)],
    );
  }

  Widget toAccountBoxList(List<FeedbackDataModel<ReefAccount>> signers) {
    signers.removeWhere((sig) => sig == null);

    return Wrap(
        spacing: 24,
        children: signers
            .map<Widget>(
              (FeedbackDataModel<ReefAccount> acc) => Column(
                children: [
                  AccountBox(
                      reefAccountFDM: acc,
                      selected: widget.selectedAddress != null
                          ? widget.selectedAddress == acc.data.address
                          : false,
                      onSelected: () => {
                            widget.selectAddress(acc.data.address),
                            setSelectedAddressInStart(),
                          },
                      showOptions: true),
                  const Gap(12)
                ],
              ),
            )
            .toList());
  }
}
